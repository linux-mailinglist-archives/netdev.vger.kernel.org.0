Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A7684E65
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbfHGOP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:15:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40927 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfHGOP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:15:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so88416405qtn.7;
        Wed, 07 Aug 2019 07:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=0eo1cuSOLKuBc/AsDSL5J5wiBJZGR8gnSw3Z4l9sYKg=;
        b=Im9mrtlTccOuh5BHDB3W0jR5+YFOCS3dAR/vurzp0zUwWD3deG7I3VvqCr4VpQDmXi
         P+ooIZ1TGApur+GvetVeZhJTUPkSdL5sDU0ukclRHTAd5+PWsFyf5OW41Ju4UFJ0hQBB
         QRVO4vHvNYIFSMvHufATTbNo4oGS4LaWnZx5kmzYxPF+UAp5hFx9e1zSnpKC2y40ZvYU
         u0aA7UEyZWdoeb+BOXirmvhYvWki1F61qRMNAa+VeKZk5KFFA/FNXE2QOvNw04R8MyDq
         sVMSv6PRU4adQ0gHCPJ46/+aaBgIuFfXt5pBZGcwzH8yTLjjBuxdBNamwEaOhUEIVS/d
         Cbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=0eo1cuSOLKuBc/AsDSL5J5wiBJZGR8gnSw3Z4l9sYKg=;
        b=KDRAFcFvnBj+oyb2jgUHem6fPGwJvzcs7bIyHa2bl9uRVuM3DuAsG41SarxzEZ9cYd
         GJhF9HPD+NP70jIqbV7wsgWWtqAmlJ5NafRYWrLdGh7rSIeUvkDsNLkkCc/fYGVf9yUn
         aivEkMzruAr2N2R9D4rmPCwlHL8ICn6486RAl2I0xmLAOMukhJhJajeMg2yqr6S0/jg5
         S+o10b3Wl6ixXpeb54UoBTx8Ht9dyZKcs1ZZe7mClJVmjy3cVsA/aAWLCN/hqa9TAp3B
         uz/8SmkpS+urYwnmU9OSvwxCrLwu/gpzS9J3JoWHNOsQiB1cb5iujfZngX/u9LLksEGP
         nX5g==
X-Gm-Message-State: APjAAAWnyY+sZbAKPGQlX5Ov0SW/mm3mYVQFaBnPN0M+aoPZQZDLqi86
        OAXTj9Nw5rF8i5awxi9zz0g=
X-Google-Smtp-Source: APXvYqydE9t34RMj3FOIIR4MbocPd8wGG7Iei7oVN0TZfy1vRak54eQ+8JyghnZbB35clnwG48ajYg==
X-Received: by 2002:ac8:42d4:: with SMTP id g20mr8356709qtm.78.1565187355949;
        Wed, 07 Aug 2019 07:15:55 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x14sm2482778qkj.95.2019.08.07.07.15.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 07:15:55 -0700 (PDT)
Date:   Wed, 7 Aug 2019 10:15:54 -0400
Message-ID: <20190807101554.GB29535@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, olteanv@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: remove set but not used
 variables 'tx_vid' and 'rx_vid'
In-Reply-To: <20190807130856.60792-1-yuehaibing@huawei.com>
References: <20190807130856.60792-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 21:08:56 +0800, YueHaibing <yuehaibing@huawei.com> wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/dsa/sja1105/sja1105_main.c: In function sja1105_fdb_dump:
> drivers/net/dsa/sja1105/sja1105_main.c:1226:14: warning:
>  variable tx_vid set but not used [-Wunused-but-set-variable]
> drivers/net/dsa/sja1105/sja1105_main.c:1226:6: warning:
>  variable rx_vid set but not used [-Wunused-but-set-variable]
> 
> They are not used since commit 6d7c7d948a2e ("net: dsa:
> sja1105: Fix broken learning with vlan_filtering disabled")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
