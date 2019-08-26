Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B201E9D8F9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfHZWRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:17:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41414 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfHZWRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:17:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id i4so19487700qtj.8
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=7e/5x0vK2ab0mcVQr0RcCoDsYF5Ld0162CJ6NrwniD8=;
        b=ACV/m6mXr+ZvuqbrUDis5hnJ/Kh7cyFc/FQ/qki3X6cGDnByoGho2HgngvlhHV1Bg+
         ZiZk3MHEn7XFe9YrFAsaKLTIzo/S0h6Nek7tdV29j4YN5wCOFFw0/5Fhjbtur5VZ7j6K
         9MJHMwPtDRD71nozsCnTfz46BX4WxbD7JeHD6yPsQp4mL3WvLZGFcMxKhs4DrwqeBZqr
         ABNFAWmTmuFcYFoJ987Addw2V2UWZX7wa2gUSrbH427ewMiifcoSLfN69ELcx4XPHSQV
         pke69Vhrii+OoKgruvJLP8uiknOOwcHCF7oYfbjo7/Z/h3/683fULJ7pIWGtAhCoaUIg
         BaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7e/5x0vK2ab0mcVQr0RcCoDsYF5Ld0162CJ6NrwniD8=;
        b=JAwzW7oNIcQeueRMtPYZNYCyAm7U1dwh/FafqoMhOUN/WshZv+amOIX1t1RH9ZfC0D
         pBeYLz+vBCc1Wg0YR5qO/O+OQ3N4Ayv71tdWlb/lt/LF8ZEM5yXqRD5ZMYHdL/XInJzz
         wPwKlb/YUxV9eIJm+I5GbD0HE1XQu17/qbCN1oJjx+RJkenxteiFw667oofwzrn4EDRt
         Y8KjikjMJNM71mo6iQOhZb17Xvu6DokDpNaiYtxe0QB0rH8om+8B/e8SWBYgFXVHfJ3i
         zTFPstl5B4AwtZOY/5vqnSAs+IUzjiXJmmmh9IGrHteCOheek2Jp9s7j5kHKvF/hWLeY
         u3nQ==
X-Gm-Message-State: APjAAAVY65RDiVcLh/MNFEI00cJY1jX5ZyoOg+o36FDhtHNNbKlNh1Js
        vY66xfaXdFvG2KhPN33nWi/hAml0
X-Google-Smtp-Source: APXvYqyCtx9q/VHdocAoQJyyxWPQHnzEJMBIrGGG3fWxVbPljFAyRQvk91ac0/Fxvut/4oMiQ+d41Q==
X-Received: by 2002:ac8:7158:: with SMTP id h24mr19613776qtp.73.1566857843532;
        Mon, 26 Aug 2019 15:17:23 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 143sm7059213qkl.114.2019.08.26.15.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 15:17:22 -0700 (PDT)
Date:   Mon, 26 Aug 2019 18:17:22 -0400
Message-ID: <20190826181722.GD27244@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v5 3/6] net: dsa: mv88e6xxx: create
 serdes_get_lane chip operation
In-Reply-To: <20190826213155.14685-4-marek.behun@nic.cz>
References: <20190826213155.14685-1-marek.behun@nic.cz>
 <20190826213155.14685-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, 26 Aug 2019 23:31:52 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> @@ -635,10 +660,10 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
>  	irqreturn_t ret = IRQ_NONE;
>  	u8 cmode = port->cmode;
>  	u16 status;
> -	int lane;
>  	int err;
> +	u8 lane;
>  
> -	lane = mv88e6390x_serdes_get_lane(chip, port->port);
> +	mv88e6xxx_serdes_get_lane(chip, port->port, &lane);

I don't like when errors aren't always checked, but the code was already
like this, so this can be addressed in a follow-up patch:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>


Thanks,

	Vivien
