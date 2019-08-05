Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8DC82514
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHESyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:54:12 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:44129 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHESyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:54:11 -0400
Received: by mail-pg1-f169.google.com with SMTP id i18so40194566pgl.11
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 11:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xsr3eyAijmgqKw4XStMyNnrn0TjS1JLfgI2THqPyWDQ=;
        b=oOMEEd6AHVRp9W0aiPsARBrLJr+yi+YCDMlE7ywq7kdQ0csUXvpI7SeDgf8HZLV7fh
         Kjs0Plgbu9zUpMMWMrOIpPQz0E9uESSpX45KCvvFBi6g74E3VNWI38M2Y4toOqJvr/WD
         3xmDX0e8C1m9jTOcfLuxN6ffNCXGYx8HhMJV6ry8UvtyEeJOh00nds/XWnRl3HRKhT3R
         LM9hWQFO8C655cDIHRjKwCxDorpGVxwwR9MbwketCm1a2H1pbEELPu/x5NsCngi5khm2
         kq/4MSSVFCEkiEiJNgfM9GuBk2s1M0gI8LlGFDfWXres4g7PP7OUvuqPaqo6vn8M10tW
         wY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xsr3eyAijmgqKw4XStMyNnrn0TjS1JLfgI2THqPyWDQ=;
        b=LS1zEROpcZRMkXKVHYzuG69RKbmcpMNjV/QLUXyikNrPU5ihkiV61HQwgUOrKoEcgg
         19mfxET3o49sM6JPS0QmUhYTRnveGrFes6ZeBMnpeA0qN1fzVrm83uy4rTkvpATj75Pc
         Srwuy94JayLZZsoXJgwYr8x1qW9lJVTfJNukykC7QZEgoIs5Odi4IzZhf3hFt+Xt8XWD
         lrMEq5Wydpe4pTQZ7+fGb0albkxS3Pjnk7LmlInAnESu7KHn/EubFATcOTkNKmALe6Xw
         hCPkN6YlP1V+Te9H1XiP27ZNvqMp/epDKnQG3tYm943DlV6Pf607Do4AUPmHIB3HasXV
         jqkw==
X-Gm-Message-State: APjAAAW85touqIWtA1TQWrN4Uf9fycpITXCwljZ8Hr79T4eoMjtnZyRx
        MHJfJDIn3jXRSpbAwA6B9uE=
X-Google-Smtp-Source: APXvYqxRT9eJxj1ZqgxQ2F2dOYIqeqz9xI1AM+4NFKw8ZWD9DViPdam5JITCIhIdJyzCbInnZYIgVA==
X-Received: by 2002:a65:60d2:: with SMTP id r18mr29869579pgv.71.1565031250802;
        Mon, 05 Aug 2019 11:54:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q4sm16537879pjq.27.2019.08.05.11.54.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 11:54:10 -0700 (PDT)
Date:   Mon, 5 Aug 2019 11:54:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, slyfox@gentoo.org,
        ayal@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2] devlink: finish queue.h to list.h transition
Message-ID: <20190805115403.7770a86c@hermes.lan>
In-Reply-To: <20190805095658.19841-1-jiri@resnulli.us>
References: <20190805095658.19841-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Aug 2019 11:56:56 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Loose the "q" from the names and name the structure fields in the same
> way rest of the code does. Also, fix list_add arg order which leads
> to segfault.
> 
> Fixes: 33267017faf1 ("iproute2: devlink: port from sys/queue.h to list.h")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks.
