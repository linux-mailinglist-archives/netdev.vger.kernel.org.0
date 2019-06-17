Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FFE47DB1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfFQI4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:56:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38111 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfFQI4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:56:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so12845936edo.5
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 01:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=nYP7nwkWft+3uUp9e25ZuOw9THhDw1ggRk0lkiQT8jk=;
        b=lAOFLfNpOvUuTJG1ReESb/ZnQ/2/zpkokfGcQ2pm7U3B/ryQAyyBLNSwP+NaSwRoqS
         U9lIIWVsfLkHWjYKJNX9okgatDFpPrHcqGu5rwGnoQigsqMslV09MLZojcrsVT7jgDyX
         nrXyhqJ9ZHGZRUS7ihpHWC4mZHqlD9wRoW57gXBHyhQhSYKH6mkGgHi9aXZFwCbmvxKs
         JVPkRYWJ6lr3YwDp2RVZWtnfBrbdFjWztay7Az2zA/5ZG15yTbT8JyJVWMbNm0djowcr
         so84g4+chJssDRGKjlNSz5ubvVvDAAEsGAN4CXgcqf8mslLPgg9lphass99teg01v2X9
         nGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=nYP7nwkWft+3uUp9e25ZuOw9THhDw1ggRk0lkiQT8jk=;
        b=s/AmonJXjaNJgjgIA554H3CvgrP6nqFgn6X/wEPLoA5Jq6tj6mECupvERBx59tPud6
         BwM1pLJpD/QpFvna2F5oaap1OlnFlO1hy1R88QBnfHfTLdMb8/OjL6tr3DXFx4fgiT9H
         +oVV2wN5a2lzGRY/gUaSUVtxxEGQM42dOebQS6GYWpSeU2vLWYLK0kGpI0TTDSgM9xbk
         ZrdEgxVQRgugL2oreY98Zrd/mt355fNNnRF/pziXcPlIsiYUeTFMlA2G5tDz1id+PoPU
         Nx4lsrQ5htFSx1ZxPFxP+G7CNT4nJl3jli4ufhpHOE4riPEktFf4uKKmNIcTHzDDkNog
         4p7A==
X-Gm-Message-State: APjAAAVEPRPh245WlqulsX/Ushde42CawUP1zdMSkeei6hBE2yWuK7HV
        RncmfUOkW/9X8Ah9pD4FbRsqHaCxsAY=
X-Google-Smtp-Source: APXvYqwylTBcYALz6DItF8lNeiu/bxiKZNfUEzJ2MwvfkvNg59Cyc/65bONS/5J26iZtM3yzFUyF6w==
X-Received: by 2002:a17:906:1181:: with SMTP id n1mr63614604eja.177.1560761812064;
        Mon, 17 Jun 2019 01:56:52 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id a3sm3394908edr.48.2019.06.17.01.56.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 01:56:51 -0700 (PDT)
Date:   Mon, 17 Jun 2019 01:56:50 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Yash Shah <yash.shah@sifive.com>
cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        palmer@sifive.com, aou@eecs.berkeley.edu, ynezz@true.cz,
        sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 1/2] macb: bindings doc: add sifive fu540-c000
 binding
In-Reply-To: <1560745167-9866-2-git-send-email-yash.shah@sifive.com>
Message-ID: <alpine.DEB.2.21.9999.1906170154280.19994@viisi.sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com> <1560745167-9866-2-git-send-email-yash.shah@sifive.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019, Yash Shah wrote:

> Add the compatibility string documentation for SiFive FU540-C0000
> interface.
> On the FU540, this driver also needs to read and write registers in a
> management IP block that monitors or drives boundary signals for the
> GEMGXL IP block that are not directly mapped to GEMGXL registers.
> Therefore, add additional range to "reg" property for SiFive GEMGXL
> management IP registers.
> 
> Signed-off-by: Yash Shah <yash.shah@sifive.com>

Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>


- Paul
