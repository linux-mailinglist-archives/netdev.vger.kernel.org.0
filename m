Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F9C333B0
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFCPhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:37:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44267 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbfFCPhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:37:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so9847644qtk.11;
        Mon, 03 Jun 2019 08:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rHntYJUbuDaq+hgx/W8n2ZESMDDGCXnZRtFMetN3TC8=;
        b=XlmNNBU9PdkdMaMNFetESigw2qJNWerg96dKJCPoh7BM92dAbMIDvW5iqVstKUIF/m
         S3KJRrY+3St7YM1Aby9bA85c+AYI/ZSvn5YVGzL9/VhypuDrS/xGnRGO9G4L4GYst7sM
         yBXdbK+SzstYCVG/iv1DV0l3PRuHODLcuHgMmvP5Fw67/OnZcMDr1WJXmcrRgO+RQtsk
         PxuWQtUzDca1DEj2K2ASNpyOMb0TaSK7WDeAqac3E5LjAejN2iEWjcd9HYDNIzaHCfQ2
         2IyxyznQbR+k/CnvIghUEQQCJtHSwcMG5nZVOUavIQ0ZAKjcQNU4PzeKSMxvoNmcx4xO
         iCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rHntYJUbuDaq+hgx/W8n2ZESMDDGCXnZRtFMetN3TC8=;
        b=GDgqW+IVnOOTbdRzbCNZRdzhGxIyZipiBFveP3Kaad5WIulSQi95eqHYFStlMQYRIU
         6BbSMdUkqeK9K7q6hjaubfBH94K7Kgf/nMklNH9MfkorzqRuPHgnYmej0EB0ECcORdky
         Qb3W+nr91T7gC1gvSUbuzTWdZ41EGJMhsJSAzTPFTa7PVCQDE3hD3YMKtk4zY43qo6Sd
         OuTXvfl++6WRcBTyMsrqPWPj6H3u36KGvCcl+PgrfNinqaXQcrXO+PUF7IzdHry8N1wr
         vM3k3h7ZKfwTqaLIDaatPF4DowUpLO9kRG8CaX+YVZw+bbWhBdRWtVq6nQ2+Fa2opNlk
         az7A==
X-Gm-Message-State: APjAAAX7kE1VkIYuauyk5V8aS9b7ddk4goaDP54ZJ6bJwGSB61j+h0mz
        o7sRT2M8uuaj7M0Ph/D2xuo=
X-Google-Smtp-Source: APXvYqy0IknxALApVjEtsBV9AdMLGg36F2dpjWNa/TKvbUcusEf+PKUzn34Mm46N887BwEy+73MKtA==
X-Received: by 2002:ac8:525a:: with SMTP id y26mr23858606qtn.297.1559576235773;
        Mon, 03 Jun 2019 08:37:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q79sm7391803qka.54.2019.06.03.08.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 08:37:14 -0700 (PDT)
Date:   Mon, 3 Jun 2019 11:37:13 -0400
Message-ID: <20190603113713.GB2789@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
In-Reply-To: <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 3 Jun 2019 14:42:12 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> Quite a few of the existing supported chips that use
> mv88e6085_g1_ieee_pri_map as ->ieee_pri_map (including, incidentally,
> mv88e6085 itself) actually have a reset value of 0xfa50 in the
> G1_IEEE_PRI register.
> 
> The data sheet for the mv88e6095, however, does describe a reset value
> of 0xfa41.
> 
> So rather than changing the value in the existing callback, introduce
> a new variant with the 0xfa50 value. That will be used by the upcoming
> mv88e6250, and existing chips can be switched over one by one,
> preferably double-checking both the data sheet and actual hardware in
> each case - if anybody actually feels this is important enough to
> care.

Given your previous thread on this topic, I'd prefer that you include
a first patch which implements mv88e6095_g1_ieee_pri_map() using 0xfa41
and update mv88e{6092,6095}_ops to use it, then a second one which fixes
mv88e6085_g1_ieee_pri_map to use 0xfa50. Then mv88e6250_ops can use it.


Thanks,
Vivien
