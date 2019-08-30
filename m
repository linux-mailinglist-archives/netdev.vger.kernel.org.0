Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87904A3ACD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfH3Pq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:46:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45676 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfH3Pq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:46:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id w26so4870917pfq.12;
        Fri, 30 Aug 2019 08:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=b7/sQrlJCB5Ujd8MG7PuZ8VzWLXpJows6OjSWqD3k3o=;
        b=tdJxplD7co3xJLSUoz1ZWfvVWP6+28apE7DuWScouTvelbRhl9rMeij+5CX8++qUAm
         QbzTtL25kt+tbbArJTBSTNvNfC7Er+FYJ95lBcW/w+k6i6/qRVLiO0GJ2UaHulBPvQS1
         0j8INwfo6oNCqlBHgZHyp0tmcEAhizoCI0RW7Mmwte6389xyMPRYksvJcicDEuLT+98L
         ketU8JjU98sDbSrxgoHMUebj3pYfu4ZgbC+O4fFv0RH4iRaeCIf7O4ZpirvHbnUFYqEu
         ZpeqTyEM/Ovs00OFU0e9Rggmi/w2MFH9NsxyGazlSnWF5cD3OLn1A07wLO1NvyfWnrMB
         /qYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=b7/sQrlJCB5Ujd8MG7PuZ8VzWLXpJows6OjSWqD3k3o=;
        b=hxGhpUGwlM7pTWZPiE2DRIwn5dMOHbzXYLTw2bvBRzsJSI1sbrVL2t3LLvmSQkYNCT
         Y6dH/z5km7uLyq8WZUMG4a7uJH4i4ptAURR7iF7AbvrcNegLZM3rEPbam1ZZSaF4DfWN
         nRdJBnDkd5KXIl21ODrFI0KTx+n7lR0RhOFVZpKAwVlL51IpFVvSME/WatXSe9pbuHYU
         JIf78V4xUeLLXA8pWBaZRuvljD0t0dzctzgOCZ1AD/5WF+3Tzy1G6Vbz2G6MLoue6Ilm
         QML/mdXa2m3+717DupcLZuqd1GYd/5N3Ou2G8rWknqrtArWjKnmTck5wDNpLvr6M0NOM
         kFEQ==
X-Gm-Message-State: APjAAAVfTGpdj+0UW2CRKwhKPbsAsqRt60BNy85iiVGiuhKd3tur9pnF
        UpswJIe/45F/tef2jlNxcGUn66rcteg=
X-Google-Smtp-Source: APXvYqxkaR8iAjrJq3grreu8mVOcL+lHZwNOYQhEm4z7xXijUgEkgnfICDRrjqiAQI9NcJUNPtxY5Q==
X-Received: by 2002:a63:5550:: with SMTP id f16mr14088780pgm.426.1567179988070;
        Fri, 30 Aug 2019 08:46:28 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id q3sm7812979pfn.4.2019.08.30.08.46.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:46:27 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 08/12] libbpf: add flags to umem config
Date:   Fri, 30 Aug 2019 08:46:26 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <97813612-8FA6-4A33-B4FA-CF7A99FFC012@gmail.com>
In-Reply-To: <20190827022531.15060-9-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-9-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> This patch adds a 'flags' field to the umem_config and umem_reg structs.
> This will allow for more options to be added for configuring umems.
>
> The first use for the flags field is to add a flag for unaligned chunks
> mode. These flags can either be user-provided or filled with a default.
>
> Since we change the size of the xsk_umem_config struct, we need to version
> the ABI. This patch includes the ABI versioning for xsk_umem__create. The
> Makefile was also updated to handle multiple function versions in
> check-abi.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
