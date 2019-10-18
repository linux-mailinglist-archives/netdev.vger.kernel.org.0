Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4660DCE4B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505645AbfJRSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:39:16 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:43260 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502485AbfJRSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:39:16 -0400
Received: by mail-lf1-f45.google.com with SMTP id u3so5420353lfl.10
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=L0gPYNWuMwWZ4hh1A9GF5ze15Df6JSdkU2YCgkeDdr4=;
        b=OKJqf7tFSwKqifLhRvUYJMbYQyNhVGT9xgSv+Q5mdG90fEOadrRv1voDy1A9mZ1Cfm
         haNsyrB3F4WTugH7hshEJJcR5i+wDywHO0c2vUME9dWk1am5fYOdbLqRKmdBaMZqYRIt
         SlUhvmtMRZ2Ke++7UquoagpjhfcyJSZT3c2adJ6I0fhdOJO9y8LTE7QnuyyjJrB2oPTV
         xG7EW0oRzo6ijt+zAbbUB9xP7SY0R4pqN2iNFfi5oFZMY2sOvXc0XvXQPrL/HZ450LlC
         5P67h7JRkk1BcFjdhMFjEaNMKtaaD8aQbMLD4x+qwaKdldwzS9iOoCbJGgodJb0xLb6u
         Q/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=L0gPYNWuMwWZ4hh1A9GF5ze15Df6JSdkU2YCgkeDdr4=;
        b=Bl84TjNjHe2YWlob0EQJtmQ0EVrsjhmUiYtga9kK3viZdU+mON7YDU283hZ481xUtp
         ECghyVClIJhRSRILO8QDd+zPoEpup0uAqUUp68IyXBwoxuLaKZMpn/zuLuIL/YlhSz59
         nis4ySLvek7ddCkQ6GFCstkV5EMKf6jMPU7iYuBNuDA3gUa3u0+87q5r/4L0aiN3g46q
         Gd0AYNxJlLFzpJycrqTH72OnTPaREdBmq2yoBu2pvkVUxS94TtNRZ3TXLsFXIjiVozxn
         mCBwzTnwhH8cptu08LldX8Ucf2GDE2EyHBHm3CYDtFyoy38A3RiXPGfqVIuL1dq/PzfE
         CoWA==
X-Gm-Message-State: APjAAAXKhm610+Cmuy625XQ2WITNhA1Nc5aYoHr8PkzLvZWeaZe+d7Wq
        EzuuRiMHbbc1iDQmixoZByNiPw==
X-Google-Smtp-Source: APXvYqxO+63ZANghOi/jHhJomzXGOjK4Vx06iFi98Sbt8Wd8QeVUOYik4kmV5cp8/tLT7fZJI0XLPA==
X-Received: by 2002:a19:4a13:: with SMTP id x19mr7399990lfa.184.1571423953945;
        Fri, 18 Oct 2019 11:39:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm3094265lfa.95.2019.10.18.11.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 11:39:13 -0700 (PDT)
Date:   Fri, 18 Oct 2019 11:39:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2] devlink: add format requirement for devlink
 param names
Message-ID: <20191018113906.683e9c72@cakuba.netronome.com>
In-Reply-To: <20191018170951.26822-1-jiri@resnulli.us>
References: <20191018170951.26822-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 19:09:51 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, the name format is not required by the code, however it is
> required during patch review. All params added until now are in-lined
> with the following format:
> 1) lowercase characters, digits and underscored are allowed
> 2) underscore is neither at the beginning nor at the end and
>    there is no more than one in a row.
> 
> Add checker to the code to require this format from drivers and warn if
> they don't follow.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
