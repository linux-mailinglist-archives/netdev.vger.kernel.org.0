Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B370F422F88
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhJESBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:01:55 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:40603 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhJESBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:01:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C0A62581046;
        Tue,  5 Oct 2021 14:00:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 05 Oct 2021 14:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=o
        6JC4w3+VquAOly1TnyRrCufThrXZQlnZNKCO1Vq9FY=; b=V0A0J+FqESYJmoM2g
        clnYQdtYOcQBLAk37I3DHGLoayFY8kqo8A3rf0kdqLZSvCReFSnKwg8Uu20mk+VI
        eEIqvmbdQqPiffV4RfYQd7NK2oEmoZTSGAmn6YDL1gbm+XtrJ5Ruxpe6RNVABobA
        rmTJlN8s7VL9gWxa4svMqXFV0OPZBOCZAiBLqCxdPR2Im1W3Jb4oPpkqG+h9Mzb+
        YudZaIRw7rKiVj6q3q5sM2hGI1owAF6nTn0oR696et2TK4NEfNirIEzTqyuYwaYb
        DaUphlHRzhFJrQ1K+sm3ya0EfKVyQpAXgPzTDPkutnkmYbm6c7hCBM6HHLz01VYG
        fLf5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=o6JC4w3+VquAOly1TnyRrCufThrXZQlnZNKCO1Vq9
        FY=; b=OYMraGd8G+vwUj8gvVbvqQSD7mmVL9ZVVsHZoRl613TuDPuRVONnjjj3L
        2+OyhhEfIjyyIb/BK/rervqy/TYXx20Vg1ITobKz3vdCIWfW1dlzf2DpykP8fT8H
        m/oKZs8DmQKMME/f7RJ1t+YEpaKhGJu7D0SdyXhLY27OmkbetX+ODcGmAkEN4xqr
        12jFaNhUe2549WvsMNJehKOdzeNFglToJsFCcI74D7o6alK0mXH7sBxZg5DFTmAJ
        uocsQRutRuDIFCoRydloStwt68EC6dsTdVPGuvbm8JA12TZ2QW57pwREHzq2og0J
        hQtPWd/uw3N/qaaooJ3EHqR8ITu8A==
X-ME-Sender: <xms:oZJcYV-ywYh9yLbyCHa8iKJH3fP8xqlC35VaJeRe2-Exf33vDMwUzg>
    <xme:oZJcYZtoRFrHg_5QNB-cZWoVAw_wZZAkn7b9Sf8eWGTcH3oRFDKZJCn23gZs_lryO
    oAJG63ZeUbLU2WxHOg>
X-ME-Received: <xmr:oZJcYTAkYLXxxvEsDnpyQCnjWEBhtfvrwPDF41Eo92T4cwcFux-HvPApXT1c8sQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgr
    gihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqne
    cuggftrfgrthhtvghrnhepvdefgeetkeehjeevhfdvfeekgeeglefftdfhffeludeujefg
    heehvdeludeluefgnecuffhomhgrihhnpehsohhurhgtvgifrghrvgdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdr
    higrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:opJcYZf0ldvFK2p1COgtBpbdMNNjhAC3ftIXLXK2JbDf7GRWVrJ1jg>
    <xmx:opJcYaOSEOIQgKjKSNYjY6BXhpbYZX8iNR7ofzxgzKG6vmiabXlh-Q>
    <xmx:opJcYbl99y39oZroUdfPHNYCGL-k749GroxC3k-o3OX32ANNEtdccA>
    <xmx:opJcYXsXn1X5-xacMejFdKogepa8ztFwwCG70-FFROeAMqzpObK8dg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 13:59:59 -0400 (EDT)
Message-ID: <0c21a563-f029-abe6-adf4-7c8c75db44eb@flygoat.com>
Date:   Tue, 5 Oct 2021 18:59:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 2/7] mips: uasm: Add workaround for Loongson-2F nop CPU
 errata
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, paulburton@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        yangtiezhu@loongson.cn, tony.ambardar@gmail.com,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
 <20211005165408.2305108-3-johan.almbladh@anyfinetworks.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20211005165408.2305108-3-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/10/5 17:54, Johan Almbladh 写道:
> This patch implements a workaround for the Loongson-2F nop in generated,
> code, if the existing option CONFIG_CPU_NOP_WORKAROUND is set. Before,
> the binutils option -mfix-loongson2f-nop was enabled, but no workaround
> was done when emitting MIPS code. Now, the nop pseudo instruction is
> emitted as "or ax,ax,zero" instead of the default "sll zero,zero,0". This
> is consistent with the workaround implemented by binutils.
>
> Link: https://sourceware.org/legacy-ml/binutils/2009-11/msg00387.html
>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Thanks!

- Jiaxun
