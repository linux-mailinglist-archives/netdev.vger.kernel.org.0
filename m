Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F44162948
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgBRPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:19:14 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35378 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgBRPTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:19:14 -0500
Received: by mail-lf1-f68.google.com with SMTP id z18so14809429lfe.2
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 07:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6DK9ubhFIC2WsmW3uSe4UN5BX9ONKouuW6vtspgtxGU=;
        b=G1KDrHLp6c12KcgDCfR/aR5mqH17Ee+nlKiI1iM6bZVLN4zg1ByAydkG1MxocIkS6S
         KqCCoC8JOzI0WCxCmLzy1JYyeXTQpaPyMJw080B8Y8N7n+SAoq/eEwg0hQtRu9XlGuOA
         7ppIpBeZ7uxd9piMNfHHb7U/mOhxPWxiHAQJ8khBD09cw61pF23H5cQd3eyojx1fuwpT
         TrlwxupAotFhnz2fo2/cO07FxxPVxVlt3qK5kNAWARvJ4bTdw/VbBLCFQ49lLfI9yGRS
         hqJkc95JCDQbgx60axVETOUkhTbQYwLNCN4Z28e1K+xZ+FsT37pcVNhFBsM/5eccBgD5
         MtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6DK9ubhFIC2WsmW3uSe4UN5BX9ONKouuW6vtspgtxGU=;
        b=KTRsPbdLeEiPvX+VmlOGBLR3OWHrwIL7ljiHYJwtfnpy1l9bgcVKf+8JpQMvqvAh/5
         C6q5CQhO/9+OH0sk8GDaolLjapze4I7FIgDcIZjOZWVV+62RffSkn8K52eZ5RyEBBnlh
         jSW1KTMrNRgEhTYpodXKvPcLdWTT9mqwSgNgp7TopI98ouv+2MA7PlttSGj1NUyIeTp9
         G8schPjkM9aJtUtYEU9b73dzElVLpKAxMIu6hQ8kBqTKwccY7V2jiIpzcc34Ci/0YMhn
         0G48YiYSed6QvBHwTpqd83t/xx/5a4Oe0+lSGksYCrcyfJ1kKarM6f426c7p04cNjl3x
         1z2g==
X-Gm-Message-State: APjAAAUjC4IWeszXlVN2OO3fhegs2fEMRV79pyTlkIife2VjqL01n6FZ
        5T/5CdqZLLpHF8e/HBM7yOo4+4yGMEl1zQI9HEk=
X-Google-Smtp-Source: APXvYqyHF5L1bLFcdFwp+DURTvxxtCcN+SSnxPO+7cPKY498tLiN8bm9lvcp0cud5p3wWK1J51Jfv1RtJBqkWJoMO34=
X-Received: by 2002:ac2:53b9:: with SMTP id j25mr10531906lfh.140.1582039152051;
 Tue, 18 Feb 2020 07:19:12 -0800 (PST)
MIME-Version: 1.0
References: <20200217223651.22688-1-festevam@gmail.com> <20200217.214840.486235315714211732.davem@davemloft.net>
 <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com>
 <VI1PR0402MB3600B90E7775C368E81B533DFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5A_LvVOEQKqbrm5xKUR5vBLcgpB6e50_Vmf5BDFsRnaTw@mail.gmail.com> <VI1PR0402MB360000C02868DB471237E08AFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB360000C02868DB471237E08AFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 18 Feb 2020 12:19:00 -0300
Message-ID: <CAOMZO5Doc_Wd0pJVcLocXCJ6+DDrJw+iZX5-JTbw-7XvaQ=OuQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation scheme
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:30 AM Andy Duan <fugang.duan@nxp.com> wrote:

> Currently, I agree to prevent unbind operation.

Ok, thanks for the feedback.

I will submit a patch doing this.
