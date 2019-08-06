Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17478381A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbfHFRoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:44:20 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37047 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbfHFRoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:44:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so9150744pgp.4
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ft20ERoDnO7a7/UEws60YLY0pmuH3hySISuvSnj3m34=;
        b=pD5s7iiCV7WiW9oM8PsGON5H3VLINyXwuDctUmgcpkGGHX/iFKpdkz0YzYSSTEdoUR
         kRM/+KY7nCYnAfK4Ld3Drl/ZBys/Cjaz+zVf2JuSSHbu6FOfaun7W9y7m52ay6FAzU7n
         zvn1HNwcNzWIaqoN4LIUXc1gjftb9lTcuMnUWMqSooukRTDMCbOLqmb56SLeTl8Ih678
         6jR/IwOJ7ZMm+MM0Q26SFOrzDelHvpWZzHFhgjUjaK/Bj7roECjIPvjDyEa2Q3xnfVbO
         xxCIJk/u6GE6z5rEr4dyfbzn4NelOtg7LvK8zzJbXA4WkvlH/bVDgFFswAUuPHihek35
         +Pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ft20ERoDnO7a7/UEws60YLY0pmuH3hySISuvSnj3m34=;
        b=nOiRA+xhHaiEH+LFCpemSnDlglYwc9EVFtZhwQ+PhZ+3vkZH0a3EUO+1rtHTRCTQ/r
         gYhMc5NcPFbXNDUMOTMZ4HoyPayMLONlErY3pWZRcVLFcYHhqlevAVkD4VavQJHYWWpo
         gW75gG2Y5CxIuUNLdV0dfNr+92gHfO5wGVc5JtdkbJxtGAR64b+kkXQYCqwSgb1fqCzD
         tlUUc1SQZGEYaIeiPc2ZSQJRYwvagUHC5RFrL83/aLsgyIC4YJhRSJQxktKmkEwNMWrX
         OdzNP4T8vY+BXX6iYZZM5wq45V+9lyPz274zpIpiaIlOdqJDoqItNP3XtPnQRneShEJV
         iX6g==
X-Gm-Message-State: APjAAAXtmN0rzIYyPkXaFOkrncjI18eVt8m5uQkZV0Os5NDd1Yun1n/W
        0w39WqYVwIdj/bBg0EeyS94gog==
X-Google-Smtp-Source: APXvYqw8dY2HNaP/X8/3qhd00TauU2ZjaTTAlGJ5ZYEZTg4KVPSSCLwSFPfEfJpzHiHDghduDy9Kbg==
X-Received: by 2002:a17:90a:f498:: with SMTP id bx24mr4396148pjb.91.1565113459298;
        Tue, 06 Aug 2019 10:44:19 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x24sm85386807pgl.84.2019.08.06.10.44.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:44:19 -0700 (PDT)
Date:   Tue, 6 Aug 2019 10:44:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 12/17] skge: no need to check return value of
 debugfs_create functions
Message-ID: <20190806104412.6e462c4b@hermes.lan>
In-Reply-To: <20190806161128.31232-13-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
        <20190806161128.31232-13-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 18:11:23 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Mirko Lindner <mlindner@marvell.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>

Did not pull card out of dust bin to test it though
