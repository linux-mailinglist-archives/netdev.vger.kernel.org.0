Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F415AB8C
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfF2NaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 09:30:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46946 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfF2NaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 09:30:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so9003430wrw.13;
        Sat, 29 Jun 2019 06:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d2Jq43JP+FXo0SKE8waIpqerNlOB9iz9yqcOCdjfmdc=;
        b=rgSoSZSshnnIj+7+FoCJgppZQCtJfnziD6J+wMfzEoJIwdF/zWTjj4NhK6tIgcQp2b
         KcM7prO9cDdIK6y4BpmUADxKBOGjlIt/+4sXbwpkIgAzatdMOgaZALI9mrOcsgn5yma2
         Q6+ZRM9NGtANblb2E6YtVySZkRviLxDS3uZivh8ezH/L/ZMSIBnO8kjgBr9jif3GirvB
         357Y1emRMgHD6+gPP5hnWnvzrp42BI30c8jZjwTGx3eIWIEHTJtLaa9IutxTto6UiXUD
         hCrYq4MYOKFEnkjkKWd1TmNVg4FKCOWV6RxZhn8wxK9IB4rs38naBUVw5X7QuXjxEYas
         0Q2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d2Jq43JP+FXo0SKE8waIpqerNlOB9iz9yqcOCdjfmdc=;
        b=Ow+rAEAW6MfdsXNNIXQOY0UHx56cIbDnq3NtYnnZuZi6cREg/moH0N2kup8qRdMxJ0
         sIAQMPrZBcMMcLwTYbQuA48h5V10M1k3ZRkBDxh07ghmdbz/BKmVjV9zKtrN5cX1+UV8
         b1GfVhHYZDPdisCCrjVyDM/2pGCONeOZEU6i+pqMvGyFfdpuv6lF/3wrICVpFTCt2W8M
         jkQhZzPEmY5NVgAR2vcPGTKx23HYHJiMgLFXwasVcn8ox3S/2m1w7TGXhdDJmVzXSvGn
         B/5cZ8wlrmrY5V3dgSMHz4Zgr5Hw7E1OdnxKdj/2vGpDZSaRZDj2C9FS9aRRYjkbbxdb
         vZjw==
X-Gm-Message-State: APjAAAWKx1IxESl6hh8l2jRTXJ9dARZyq0g/aJAn36OIKj3JYWyHq4Gl
        5zLCMpNqMyXt4Td5P+FsT++QnHo=
X-Google-Smtp-Source: APXvYqwh3xpHdOYn1eXmBfg/Ga2I52jr36q3cei/9YvigCSJizufx6uHf7inNqFe+7in5AtbjjXuew==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr12676093wrv.346.1561815018265;
        Sat, 29 Jun 2019 06:30:18 -0700 (PDT)
Received: from avx2 ([46.53.248.49])
        by smtp.gmail.com with ESMTPSA id u25sm5195676wmc.3.2019.06.29.06.30.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 06:30:17 -0700 (PDT)
Date:   Sat, 29 Jun 2019 16:29:59 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     "Hallsmark, Per" <Per.Hallsmark@windriver.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] let proc net directory inodes reflect to active net
 namespace
Message-ID: <20190629132959.GA9370@avx2>
References: <B7B4BB465792624BAF51F33077E99065DC5D7225@ALA-MBD.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B7B4BB465792624BAF51F33077E99065DC5D7225@ALA-MBD.corp.ad.wrs.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 10:36:06AM +0000, Hallsmark, Per wrote:
> +struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> +				      struct proc_dir_entry *parent)
> +{
> +	struct proc_dir_entry *pde;
> +
> +	pde = proc_mkdir_data(name, 0, parent, net);
> +	pde->proc_dops = &proc_net_dentry_ops;
> +
> +	return pde;
> +}

This requires NULL check at least.
