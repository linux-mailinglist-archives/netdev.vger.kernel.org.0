Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0946C377
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhLGTZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhLGTZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 14:25:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D315C061746;
        Tue,  7 Dec 2021 11:21:56 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z5so76094edd.3;
        Tue, 07 Dec 2021 11:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2zqgm+cpzAYaAtUUhdDUsPRmz5CsDUtCPkTvBobe8c=;
        b=L6e3NiApXs4b0TErmLD/NuIY74ISQYuBbeP4zSlrdfVOqprkxhCtU+458mGYNG2niP
         k+JGXB4vzrr1/Wnxu2x+Ty072DigFAAeoLylZOMtj+dZXCt95NKKrmIQuoy0Oh75A729
         3t5c4uVFl5gLqpkrurJQYQ8SzXk+vlq5SLWkzGeeTiibcmPJK6LZ0Hi/g7KYmp9EkyWR
         JQ4PlYP+SilC5GH0YBj3/rBfUcIdB9nxEV0TnvNsj5ERPcIqU9N6EHjL5bApIx+5FMbE
         UIZ4I2WSEsGARIkZVgSU9R/fRpsAXVyGKfdHJt5QeVw3rCi/ausl2zBNnPBoHadXR/Os
         8zHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2zqgm+cpzAYaAtUUhdDUsPRmz5CsDUtCPkTvBobe8c=;
        b=b3eOE/qcd+gBAicm73APlsXXVvbf/TPUlZ1Zvwf8QBrjy+6wLx73K44wbyu57j/ici
         Aqi6DXN05z/kyd1JbRT9+siUgBCiAHjtn2BQOAwpxYHhYa1mb12k/qqnqxpK8RNV5dk1
         2ZTzO02E8BkE4nUnyl9TAOlVozRn/w7qhrciGw12t1Y1RTSDvcFP8GVN1Nq14hsJCfkr
         QBf8lVvhXR4ChN0WMojZmw/6fwikOPt/FE1FLXFCrkmSWzDwtayC1PieN0+URqmPYItB
         jDv33jrXa+rDZEiG+tM0RSVs7SQCTcpURPpmYNVQgshvBsXl3yixhDMZt4Ye451q11br
         gxRA==
X-Gm-Message-State: AOAM533lM3bWqsYbVMfIdoIWK9h1x5bwU+6iEc9D4fH/z7b6Fq1vvHi1
        pffZ3PkqpBDHnIcJymr5Qzg=
X-Google-Smtp-Source: ABdhPJwu6lbxGTt3wsEP3O3G8F1f2+k5AH9HtvZd6cPAyhfYnHdxXpstdJVwAsBMSodbFUDiuOmlGw==
X-Received: by 2002:a17:906:5d09:: with SMTP id g9mr1628012ejt.3.1638904914849;
        Tue, 07 Dec 2021 11:21:54 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id i8sm566278edc.12.2021.12.07.11.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 11:21:54 -0800 (PST)
Message-ID: <61afb452.1c69fb81.18c6f.242e@mx.google.com>
X-Google-Original-Message-ID: <Ya+0UKxWaw/LYrS+@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 20:21:52 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya+yzNDMorw4X9CT@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 08:15:24PM +0100, Andrew Lunn wrote:
> > The qca tag header provide a TYPE value that refer to a big list of
> > Frame type. In all of this at value 2 we have the type that tells us
> > that is a READ_WRITE_REG_ACK (aka a mdio rw Ethernet packet)
> > 
> > The idea of using the tagger is to skip parsing the packet 2 times
> > considering the qca tag header is present at the same place in both
> > normal packet and mdio rw Ethernet packet.
> > 
> > Your idea would be hook this before the tagger and parse it?
> > I assume that is the only way if this has to be generilized. But I
> > wonder if this would create some overhead by the double parsing.
> 
> So it seems i remembered this incorrectly. Marvell call this Remote
> Management Unit, RMU. And RMU makes use of bits inside the Marvell
> Tag. I was thinking it was outside of the tag.
> 
> So, yes, the tagger does need to be involved in this.
> 
> The initial design of DSA was that the tagger and main driver were
> kept separate. This has been causing us problems recently, we have use
> cases where we need to share information between the tagger and the
> driver. This looks like it is going to be another case of that.
> 
> 	Andrew

I mean if you check the code this is still somewhat ""separate"".
I ""abuse"" the dsa port priv to share the required data.
(I allocate a different struct... i put it in qca8k_priv and i set every
port priv to this struct)

Wonder if we can add something to share data between the driver and the
port so the access that from the tagger. (something that doesn't use the
port priv)

-- 
	Ansuel
