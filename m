Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B614677A1B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjAWL1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjAWL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:27:16 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D60233FD;
        Mon, 23 Jan 2023 03:27:15 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so8294471wms.2;
        Mon, 23 Jan 2023 03:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4yTdcDBJTrs5Cb/iupgl8JwyhPAoj/hrBf//3NRcvVg=;
        b=lVec4DTVF5z/qPr2zRKruSAD81T/QgRBukIE1vI/EBKwcPV79CP1utJcaQs6Qdvnjr
         otAzdUu1bFw4vtKJqwqkOUYvZOkhJ+bfbrx6jPNM/5exoNVV1BflpImODESZVXCScr3c
         tVxtYHPU6M5NwfgICzzLFoI6E1OfEuGSA27uto9jsrzfaKEpfgk7i1GVNt0IkrIYHzLH
         9r+HKdCxfWfLDlsPYtQy9SOHiDjheEHhDc3NimxI/v3JgsJCMvHejHSLJRJQo4UOLabu
         YgVqYnRwHE/4frs2/kmI4a91wpGpcPQFQp44+b5lOH2JWv/X62iXLl37dseIYXFqdsIN
         z8zA==
X-Gm-Message-State: AFqh2koAdau4LYRGE2PQ6OSQldiT7n2D/0Pbh5RCcF3jPc1OfC0sfirZ
        TdmOlDdDC4pD1IyByYZ+W98=
X-Google-Smtp-Source: AMrXdXvdjw20Lv7I4+W+Hg4dvw9yXtwgL3LEooExW5vSfd6qFA+Kr64gkQWRX15yiaon5VnaaEWpJA==
X-Received: by 2002:a05:600c:3551:b0:3d2:813:138a with SMTP id i17-20020a05600c355100b003d20813138amr31584379wmq.35.1674473233474;
        Mon, 23 Jan 2023 03:27:13 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600c46c700b003c6bbe910fdsm13400157wmo.9.2023.01.23.03.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 03:27:12 -0800 (PST)
Message-ID: <6f9da88c-f01e-156b-eb19-0b275c46c6b5@grimberg.me>
Date:   Mon, 23 Jan 2023 13:27:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bryan Tan <bryantan@vmware.com>, Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>  From Israel,
> 
> The purpose of this patchset is to add support for inline
> encryption/decryption of the data at storage protocols like nvmf over
> RDMA (at a similar way like integrity is used via unique mkey).
> 
> This patchset adds support for plaintext keys. The patches were tested
> on BF-3 HW with fscrypt tool to test this feature, which showed reduce
> in CPU utilization when comparing at 64k or more IO size. The CPU utilization
> was improved by more than 50% comparing to the SW only solution at this case.
> 
> How to configure fscrypt to enable plaintext keys:
>   # mkfs.ext4 -O encrypt /dev/nvme0n1
>   # mount /dev/nvme0n1 /mnt/crypto -o inlinecrypt
>   # head -c 64 /dev/urandom > /tmp/master_key
>   # fscryptctl add_key /mnt/crypto/ < /tmp/master_key
>   # mkdir /mnt/crypto/test1
>   # fscryptctl set_policy 152c41b2ea39fa3d90ea06448456e7fb /mnt/crypto/test1
>     ** “152c41b2ea39fa3d90ea06448456e7fb” is the output of the
>        “fscryptctl add_key” command.
>   # echo foo > /mnt/crypto/test1/foo
> 
> Notes:
>   - At plaintext mode only, the user set a master key and the fscrypt
>     driver derived from it the DEK and the key identifier.
>   - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
>   - Only on the first IO, nvme-rdma gets a callback to load the derived DEK.
> 
> There is no special configuration to support crypto at nvme modules.

Hey, this looks sane to me in a very first glance.

Few high level questions:
- what happens with multipathing? when if not all devices are
capable. SW fallback?
- Does the crypt stuff stay intact when bio is requeued?

I'm assuming you tested this with multipathing? This is not very
useful if it is incompatible with it.
