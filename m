Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C46BABEF
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbfIVW0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:26:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43034 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbfIVW0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:26:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so7856343pfo.10
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1sFK61oUgqTUxUpxUiqsl6lQSNHdbhMzERalasfMwlM=;
        b=Ywwl1SvxcgwtUppOmsgJLh+h2Ktkybgp4Vaz60SiIbKtvB1T1dsQGvBpVTiSPJ4bYa
         1qGFtfriYz4HlLKI4jr6q3I1ZtohSL9s2jglVQQEgFTTbNyCyq9Rqw7ivrBTRcifK4S/
         uHO2W2SdD7S27fGbs79iEGknXjYQ/+S/J/2Tjh/EWonGk0Ndnms8xZcEOzgUV4zaUxt/
         M3J8q589xxu9nDBYUrNfnS5lHECL7smxl0KQ60ErNkiUtUUX4Kt7m2Lb8DgaO1kO/aiB
         9hgX5TQVYLALaXuhUnQsehHBs+9+GqTykdtjFpY3fj4QsceSspM9FFzJ3uVtnWWNJOh3
         Pnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1sFK61oUgqTUxUpxUiqsl6lQSNHdbhMzERalasfMwlM=;
        b=o5Sk/MyXg5dadUzJr+7G37bZYcOj44pTjGtYmAEVimCFyi3+A6AZPxm4D2UkH0DBi9
         WjPEv/VLo8vWOu9RWLCHguSBbvp+Ii+4BoJx4qxBPORrCMDzVV+SmN49BM0T/Va8Y3qG
         cDK0M4BRTZig40iIARo4kq52Ia2AluxeOqKjJ/PrbVN7ZJGycxCVciGF3C5b07bDYHK9
         erXJf1Gp8jBth/pxvNjrO9/Jh5PO0eyXQdI2TMOXKk6dF0tNa+58M4deSvhd4sN+eJ0s
         Eo9PyvorWFja2UbzG6TbMDbY+N9NXAUM470JYOd7g0NwqIbUtO5aq/pyNXH1/tZ5Hozg
         En/Q==
X-Gm-Message-State: APjAAAU5j6fBCCOUXUmRuyKZYRjIYMk0b4Nj0XtTUaIYqJT4mc+Sxtnc
        WRyVbc/B4ghf4hsTZMvuIDhOrg==
X-Google-Smtp-Source: APXvYqx3wbLK6wMJ/WfshHZeRj3cjQnRgP7ZB71oVaFz42qy5jeUxtXdRvPoDikZXJxqH1xLOjkVpQ==
X-Received: by 2002:a17:90a:c212:: with SMTP id e18mr17011375pjt.110.1569191212590;
        Sun, 22 Sep 2019 15:26:52 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c125sm11159763pfa.107.2019.09.22.15.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 15:26:52 -0700 (PDT)
Date:   Sun, 22 Sep 2019 15:26:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: Use the correct style for SPDX License
 Identifier
Message-ID: <20190922152649.1fbe1df9@cakuba.netronome.com>
In-Reply-To: <20190921133011.GA2994@nishad>
References: <20190921133011.GA2994@nishad>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 19:00:16 +0530, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Broadcom BCM53xx managed switch driver.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied, thank you!
