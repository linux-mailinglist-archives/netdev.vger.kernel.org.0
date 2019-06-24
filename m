Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5515005C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfFXDt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:49:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43205 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfFXDt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:49:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so6682938pfg.10
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 20:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=60Gb60t9QM7BLWFsG5vxzyOFq757j1cPtOiCZRnqvBc=;
        b=F4yfDfEvymTP3PNNE7ArXbjyUfTKsTBxlrq2N6DhfgKd1WDm8hUtrv6ad/qAVYFMgu
         6CYIU8JH6gerSK/sQHFj7QAtRu/aw6hh+npdeTbGW0sdUh7yPhGXwlJR2mfoZ/APf7Z+
         z0iL5xYYyyu966K+OhT9cCGPLudH8Yu3CyVFHBRoFjRVhWVFayJRToWaEBZePH+kQI5c
         GnZvDYyhOQcsx3VatoPQNt7h4HkzYWfeCvMHsU9IOijifo7DJQ1AkBd5Nfhmjo2Vsvyt
         otZfjQujX00UIX1QSsNqOkivHQahnX8BZjHDChc3WSPVgw9EkC6XWU9ZZ2Ig9yYuF6/a
         zWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=60Gb60t9QM7BLWFsG5vxzyOFq757j1cPtOiCZRnqvBc=;
        b=ZK/314zkZS/+TGN0pYGzt6rMUO27XTlYMJwieBtn3aVbvnaQS4LcJhyKp0tgdW1fWZ
         45iJNIQlcRTRYNEqd1kHYuWf37PLVpkAhuifCmzZYn/WAozniyhdy0VvGTFWMeZu6rdM
         tZZ5xwBFUK7PFDDKJ5fVuaXj/lCx9fw5ETjvtzKxuxGjIPtxt00PlpdQbIOcu+e00umI
         seUcXdyxCt6bfRCehGb775Gtcy0IlNhCI9C9V9R5+4nJkQuvB36Vqq2Z5I5wc/sXo+fN
         P3sKZGAXyMu29eRKSTtusH6AAE7UVFJMakg1D1Jzn6FCS8VoXX4E9eKoawGWNQJxSBhW
         f5bQ==
X-Gm-Message-State: APjAAAVM5kJPVlyG8akxYHpU2YW345zPr94VOhKTeh8HxRM9AhKLnkEd
        r9BlRFUqToH20GIC/eSrjrPA4ZBv7HQ=
X-Google-Smtp-Source: APXvYqyeFVPbxi+z2OakbUHzdV2sXh3pkIrC6WMWXdyUZVxsY0sbLqEUStXCF3p4X5OrtOm06hvhYA==
X-Received: by 2002:a65:63cd:: with SMTP id n13mr30634063pgv.153.1561348197575;
        Sun, 23 Jun 2019 20:49:57 -0700 (PDT)
Received: from cakuba (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id j13sm8152009pfi.42.2019.06.23.20.49.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 20:49:57 -0700 (PDT)
Date:   Sun, 23 Jun 2019 20:49:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
Message-ID: <20190623204954.3aa09ded@cakuba>
In-Reply-To: <20190622150514.GB8497@lunn.ch>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
        <f5f346ff5f727f1ccf0f889e358261a792397210.1561210852.git.igor.russkikh@aquantia.com>
        <20190622150514.GB8497@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jun 2019 17:05:14 +0200, Andrew Lunn wrote:
> On Sat, Jun 22, 2019 at 01:45:12PM +0000, Igor Russkikh wrote:
> > As it was discussed some time previously, driver is better to
> > report kernel version string, as it in a best way identifies
> > the codebase.
> > 
> > Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>  
> 
> Nice.

Indeed!

> Devlink has just gained something similar to ethtool -i. Maybe we
> should get the devlink core to also report the kernel version?

I don't think we have the driver version at all there, my usual
inclination being to not duplicate information across APIs.  Do we 
have non-hypothetical instances of users reporting ethtool -i without
uname output?  Admittedly I may work with above-average Linux-trained
engineers :S  Would it be okay to just get devlink user space to use
uname() to get the info?
