Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACCA9D525
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbfHZRoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:44:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44361 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbfHZRoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:44:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id d79so14678962qke.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 10:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=53PbEo90BWGmPXVqsMwxG8Qm856QITbIguO+o+UQmk0=;
        b=jGzwobNLBAvwT0FO3+Z+UGcZViYX/k7VcmPGJB5ZxSrenusP/6W+E/S++F9Z6tBkiY
         3FEjunl029n+s5Gl5PbDToe8VtcyTl1Ulsx7UcU5vQydnfV3LSzxMWSZl4leEtfSQdvn
         5FV0y5gHUUdjYQUP9A6SdBUjI3PnQ2Xgwf9VeBLQG4L/oPWt+BhlyPF1JdO6sH8I+1pQ
         jw6MczCaF0h31gACfqJv6tUUkxBhXUFlibadwsRxiL85N2KZz7N3FroOf3z5wVunWUOv
         15xY4WvQmJcWIZENVLC5P9Rk1ISuV4ny7V+ohQJtDTwYIsd99ccBwyQSdHsP7RUluwTs
         pA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=53PbEo90BWGmPXVqsMwxG8Qm856QITbIguO+o+UQmk0=;
        b=RkNsMBCr82MgYmml+3vgmFbWHgg0UBN1BwiulFA7uVKYX0X1Vzhj1+uDHVRZeIgvP/
         CbsccuOyJFkV9uvpGgHxUlk7AI8p7GVOyq2zc7qxwZIUwT+v8y+8OT616Sq1YAlPArPx
         iTbUcVggf/U5WEJ/XjBl4TnAhVoumS2T9QxEqVlqr1Om2+RXJENjQTO2NBkQhMnUS73J
         5qyEOxM2wet5gylgAz5SQroEakAP6al7EDV/agmfklzk2oLG8YStMxPFAlevyMkZEBfR
         YM6FWma4u0+g4rUOX4rjNVAnZIw4OOjtu2aj2RtReCqM9B/96+iUW3Zg8Bw+maNJhNg/
         gAWw==
X-Gm-Message-State: APjAAAXxz7rNGM3r7QpxoIwU+PeKZAjhZQE9TCHpQCb3Vrd9qnnfyGHX
        t2nZkGni3t6kiC9ehzcU4QQ=
X-Google-Smtp-Source: APXvYqztP+12twgNkHbY3DLjUNgj+IB2UCUQ/o1qBe6EQvsIJ19LSPp+m2GB2dBbDJEb/7wUHgclqA==
X-Received: by 2002:ae9:efc6:: with SMTP id d189mr16861417qkg.323.1566841460665;
        Mon, 26 Aug 2019 10:44:20 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a135sm6419681qkg.72.2019.08.26.10.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 10:44:19 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:44:18 -0400
Message-ID: <20190826134418.GB29480@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] net: dsa: mv88e6xxx: fully support SERDES
 on Topaz family
In-Reply-To: <20190826192717.50738e37@nic.cz>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-7-marek.behun@nic.cz> <20190826153830.GE2168@lunn.ch>
 <20190826192717.50738e37@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 19:27:17 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> On Mon, 26 Aug 2019 17:38:30 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> > > +				    phy_interface_t mode, bool allow_over_2500,
> > > +				    bool make_cmode_writable)  
> > 
> > I don't like these two parameters. The caller of this function can do
> > the check for allow_over_2500 and error out before calling this.
> > 
> > Is make_cmode_writable something that could be done once at probe and
> > then forgotten about? Or is it needed before every write? At least
> > move it into the specific port_set_cmode() that requires it.
> 
> It can be done once at probe. At first I thought about doing this in
> setup_errata, but this is not an erratum. So shall I create a new
> method for this in chip operations structure? Something like
> port_additional_setup() ?

No. Those "setup" or "config" functions are likely to do everything and
become a mess, thus unmaintainable. Operations must be specific.
