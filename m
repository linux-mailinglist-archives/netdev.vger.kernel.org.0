Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540989B6EF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391264AbfHWTRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:17:14 -0400
Received: from mout.gmx.net ([212.227.17.21]:55547 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391004AbfHWTRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 15:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566587788;
        bh=PYwkSQaOmLlDfTgr5PJmdiL8V1pQsxSwJpG8MAQVgyg=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=YgfYXTPNQ5ltmVjxsFFqY82+kUI8q9lCQx9bvFru5vAib/RVhfchu+BRb0fnK76xg
         Le7GsDRywP9h8wBI8FY8h5Z/R9fW0xG4R8PXJYBqobf4MFcUEVoKYbxVgDJjpopgIo
         BGsGSC7g+hbimTcBoA4IpfhuONkBVeXGyQI1YJek=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.106]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lrw2c-1iE3Xe1dHy-013hSn; Fri, 23
 Aug 2019 21:16:28 +0200
Subject: Re: [PATCH 3/3] net: qca: update MODULE_AUTHOR() email address
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1565720249-6549-1-git-send-email-wahrenst@gmx.net>
 <1565720249-6549-3-git-send-email-wahrenst@gmx.net>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <60e92c51-814b-3811-84ca-e7fe09ab7442@gmx.net>
Date:   Fri, 23 Aug 2019 21:16:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565720249-6549-3-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:sGxjL8zEZSy6uAXZQbkTxhTionkpuKiE9UjSR7eY5KK/zpJ312I
 32uFhHpggm581SuNGBf+NJwcThSR8nlqnlyMaWAdOAGXAft+sDd9UnEfPrF94RYDkb/h7xY
 gw110VdQVfKNK7HNOuDR0GYzm+eAM4bJtFvSjWZKVcZbJw9QbwJ+T6GF2exSz9kexHVYjXM
 Mn+8oF/SgmZK8orQKXQjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DSphZvEX7Ak=:lbvhUWokq0KTsgkSjAmzdy
 /3CsZxUGB/OwsYuUPawPCU55QdIw0YBQaN4APSujX8fJT5qZRrvC0r8yp+OdJnvTHA4v0LrhC
 KUVdHHFsZdG5aw9yIKntRSyeBaMzm6TzXr2MWYwxnW2RUJ+cAJft/3t8vkTOd8rSKHGCdiudV
 edpuVadHKxnvZjlftpFihSRKVp1gWVAD68/zWhi2nAjljtUrQaqH4vFgFB82YqNqrswr5AYK1
 5sO+H+8BggkzaBEWrCUVDOMSqHxqrKqXztrxWY2aRSCNv5KbNthyaG3OFhz0i13tWtkFAnpTf
 ijA3jIPl6EdutMUCiH6vRiG5gyaR2NazTrtuRdjkUDw0HR/nu+Xu8NwTRQbw84ipQKssXLKLH
 oFqTVH0/99lSg3DXbVT5/eR7kuv9vF4rISKJzwzkINk9xFK77sMp6mE0n5cM3Oq9WgJRAGDyU
 VsTnBJWQPZXTsK7IcdUSM4f41cYQP/MRm1KZLCeugzFrvrq3jG37zGXC0Lgg5Su1aEoGrrRQc
 7oLkhPOe39nbcJoTO7lHrhbpho7556CyH36aKhhAe4tO9im/NU6MCJCf3bQ3uBZQqSKwNjaPc
 l0YaFwYs17I1d5quF0zIZiK6TXEJl5NH4/9KFA5tlI0ehpzNLei2RQtj0JCgUuvHBVW+iAs6o
 POmZzUs+3ctDGa/h69dIyQ1MWR0zYQLQ/AB8sQngVuE3Oe1HcSIynyuTkqCNSc6FzrRoAmh/+
 Xq9uxw8gyp61vivaXaLtCyrYhDbD+7stRWWo7VGgWxWza6gtFc30PPivt/aDiVTjYUEkkuJQV
 yKcNgwtTXICLHUhEho6ZsXSQpQUQM+eTre0TXQt0gpat5zHpjNt8a1nzUNtzvScAFfqWT3OeO
 cshBE1poeebgNtyJZ/mEOlvncguz6uFPHUfg3ME6P9TithIhm49eTIgU5ivMLkT/xcreb/rSe
 oVbAIYjjhwMZ711Qr920GNAuCglkrP5IU5YbR5Er3sYFKG1vRHD3k0cRWSBbDI5O0bQGYa6pH
 ZlhxyTbj0XNKgLHjWqeyQQ5Gk6Vu9BUUdD8xFz3WjiM26L6if/SfNeXXz+i0ok5cXXtqmZGGc
 Ew6QdeCfvaiPtHpOLC4F0KSMN2A+KJsxU4xlPE7AWMKdUWTF/usPzyKj7Sf/AbpXB1fuUA3tB
 YWv0c=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13.08.19 um 20:17 schrieb Stefan Wahren:
> I2SE has been acquired by in-tech. So the email address listed in
> MODULE_AUTHOR() will be disabled in the near future. I only have access
> to QCA7000 boards at in-tech, so use my new company address.
>
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Gentle ping ...
