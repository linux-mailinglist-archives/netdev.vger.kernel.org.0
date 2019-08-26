Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F679D534
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbfHZRug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:50:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:47056 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbfHZRug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:50:36 -0400
Received: by mail-qk1-f196.google.com with SMTP id p13so14729374qkg.13
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=j4otqekf2y073TPszY6f0Q/puMC6OejAY3jzM6S77fk=;
        b=cAa8DvUwH03hmitKNpCfYq2ZtNb1Zoa+2ahaXpNInew2EiZrmQykA72zynNkBc6J/F
         P1AjA+ro5qgeEZNwpMBrB4spGfT9t3C5JFPym8SdBJBhhMggbw+6wzIWfgKy54LxquCH
         1yP4FONOB622I/h3G0MLVwvbAVga2iRSxCv++Eh1l8F8wFpZmTp/7owLDMS+WHGRAzd5
         azefwDW0hWXp8R1pySPE8K5X0jatsIfw1OJl1TuvCBbxU375EDRn0UHdPu7AHx1RXRmH
         e8DyyTGp9Z8AvufxJpHeocyUUIZim0zdbwmFfatiEyYrEGSDFHML/XIff3w4lf5C7QOU
         qf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=j4otqekf2y073TPszY6f0Q/puMC6OejAY3jzM6S77fk=;
        b=gzG9PFv+/I3PrwRtVUxk/iBgoiqAotKc7Vatw1Cob4+jqHv1pclXvjE+0O/M+bJWVj
         ui/lJDu2S+jlFXXt6rfVSrcKlkKydn/9k7ucZ3CmmrbFBlwDGvFi1Xavt7Y58EMXJCIH
         IIsX01CMeEd0wzHQtg188MjF3Wy8KIhAex+z2wGC2fIpGC2ZVChLzmVS6PVDBLasMb1d
         wQvNBasyiIh88r80GB4v7H6QV27Prv87PQceDM04Lb/a+qW6qH0fBC8g7DhUlijQAiYt
         D7uAH5mDCHVW6Q7l7KwxdMpUQ4NUDNIlXWO469IZ9vYaspr1qvVH0g6fAh21UOzaE1/h
         Hu3g==
X-Gm-Message-State: APjAAAXYAr5115+9YMMRNwGaQ4tw6IWAMsiKzKxMlLoU5XvWmY2lAePz
        YdvuMFwX0Ii6MhmU3azm+WA=
X-Google-Smtp-Source: APXvYqxsdzv0voA2/Xsg1QAdJtm9Hm4CiSzckqiJtjRgtB3NDmPEJ9fE5kNvrZiNBRhjvQF5N1xZnw==
X-Received: by 2002:a37:e506:: with SMTP id e6mr4098406qkg.326.1566841835353;
        Mon, 26 Aug 2019 10:50:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z1sm8385953qkg.103.2019.08.26.10.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 10:50:34 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:50:33 -0400
Message-ID: <20190826135033.GD29480@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] net: dsa: mv88e6xxx: fully support SERDES
 on Topaz family
In-Reply-To: <20190826193125.4c94662e@nic.cz>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-7-marek.behun@nic.cz> <20190826153830.GE2168@lunn.ch>
 <20190826193125.4c94662e@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 19:31:25 +0200, Marek Behun <marek.behun@nic.cz> wrote:
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
> > 
> > Thanks
> > 	Andrew
> 
> Btw those two additional parameters were modeled as in
>   static int mv88e6xxx_port_set_speed(struct mv88e6xxx_chip *chip,
>                                       int port, int speed, bool alt_bit,
>                                       bool force_bit);

"AltSpeed" and "ForceSpeed" are two bits found in the MAC Control Register
of certain switch models, which can be set by this private helper.

I don't think that is the case for "allow_over_2500" and "make_cmode_writable".
