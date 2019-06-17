Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8E9480D4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFQLec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:34:32 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43995 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfFQLeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:34:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id e3so15632539edr.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 04:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=9vPSLa5+XLyQJw19zpdaml7fRJQhxguAtOgI7YT73oo=;
        b=YaXNNhpEEHuGAVVYKiFjcIjtnlRn+SX4KK6cHn4Pg7lywkMBTaTfMWwp9ZftE10ZTr
         nuJ/UU47huRRPPSztqkz4DT7OKeZiKaT3eRLIl1roljXdiZqjxVtFlg3kLPfsMBLX4Un
         7ceatCqEab2IpD+LDjdjSxFc3CPR7yAI7ByqoRuTM6zTdeKEHebGRoQcAkX8h/0DLvtx
         mU1LmYOU6smRlrahMdW/qJObnQsEC/dU3qrlVLLrj1wviK4LfngoI/syjUqsbWjuk/se
         mN/ZqzvXU79WwIu8OvQHKDBC0nfBXRps1lnFQdEllgWHSwdSXd1mJ+KOqrNNWMbWO75W
         khiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=9vPSLa5+XLyQJw19zpdaml7fRJQhxguAtOgI7YT73oo=;
        b=RlK27N0c3MAbWNKWV1BNaesexEbiYGIgu9K8iYhkd7ruOhWXxLXnWIE5AbEcjMddAp
         FzFMDAGAcx5LmjUS69cuCE3Kv8F7Gvo1hrcYeClHq4UrkoPuzGpctf1nOMfrBzzyrn6N
         kQHCsvaOkHhRQos5pLCiwxBljTSTFQr4KA+r1LgAj0QfOvir7pR1u6q/CKNr5C64eoKz
         fY3MURVbcmt4m/XrOEt8pxNr8YdTGQ0NaFJi5aakClZxD5WHbtySAB66JYVHHUrRMREJ
         0n6p7pIjzFJAal4HYYS5y4bXm/63MUe+JJuLEATCsoOHZpSePQQ93WPFE9RBuj322MPv
         gfiw==
X-Gm-Message-State: APjAAAXSEkzdByoM6EOkF3n5uRI4U/ocYP401Z17DIrwVXDhdE1xtA0y
        +aGZ0M62LViu8qWIN5hXkNI/Lg==
X-Google-Smtp-Source: APXvYqw1q+5ssz4QySIjZc498AMwl614ceV96qiEMFWPDNSLJ7oh7ctcvwS8zNJc5j4OHthaIvZI/Q==
X-Received: by 2002:a50:d0d6:: with SMTP id g22mr46189168edf.250.1560771269879;
        Mon, 17 Jun 2019 04:34:29 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id s5sm3434216edh.3.2019.06.17.04.34.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 04:34:29 -0700 (PDT)
Date:   Mon, 17 Jun 2019 04:34:28 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Andreas Schwab <schwab@suse.de>
cc:     Yash Shah <yash.shah@sifive.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
In-Reply-To: <mvmh88o5xi5.fsf@suse.de>
Message-ID: <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com> <mvmtvco62k9.fsf@suse.de> <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com> <mvmpnnc5y49.fsf@suse.de> <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
 <mvmh88o5xi5.fsf@suse.de>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019, Andreas Schwab wrote:

> On Jun 17 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:
> 
> > On Mon, 17 Jun 2019, Andreas Schwab wrote:
> >
> >> On Jun 17 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:
> >> 
> >> > Looks to me that it shouldn't have an impact unless the DT string is 
> >> > present, and even then, the impact might simply be that the MACB driver 
> >> > may not work?
> >> 
> >> If the macb driver doesn't work you have an unusable system, of course.
> >
> > Why?
> 
> Because a system is useless without network.

From an upstream Linux point of view, Yash's patches should be an 
improvement over the current mainline kernel situation, since there's 
currently no upstream support for the (SiFive-specific) TX clock switch 
register.  With the right DT data, and a bootloader that handles the PHY 
reset, I think networking should work after his patches are upstream -- 
although I myself haven't tried this yet.


- Paul
