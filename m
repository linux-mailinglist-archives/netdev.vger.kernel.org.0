Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF612EC159
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbhAFQmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbhAFQmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:42:31 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FDEC06134D;
        Wed,  6 Jan 2021 08:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qZq90mmL68TTEu2JR4PK3LFmriBAdAePndUjOjY8mwg=; b=OcZhu5sfoSwgx9xpuoqXf/ekjy
        vsJ1bTkkDyjVLU3hznXR3X429kRne9UKKpuWQu0zzchRkhrmo94Cr2O+L+yTXVIAvxyGqfiaskFyf
        +DrIU+/DiNEcg2q4Lht0qTfjix4wsjD9ac+kJC4Hsq9il83r2plQiHrZ88+orp/YknY7IMUiHg5Da
        PY6Qm7/OZaZAViCLnmfgpgy8UpBAR4olNyuQ7UyFloCpcD2FitStpCghfdtyrNZ39TdLZ/xA6ju09
        Rz8b5zIDNAtwEwsHQnFJlUkzlFftwrcwo7ltTb5RJOPm2rpgdFAJOIcq3i2ryU6B3/hduSEaQM13m
        h3voRpPA==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kxBsY-0004Ia-Es; Wed, 06 Jan 2021 16:41:46 +0000
Subject: Re: [PATCH v2] docs: octeontx2: tune rst markup
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <878ae398-818a-4859-6968-e04070b34d15@infradead.org>
Date:   Wed, 6 Jan 2021 08:41:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 8:17 AM, Lukas Bulwahn wrote:
> Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
> reporters") added new documentation with improper formatting for rst, and
> caused a few new warnings for make htmldocs in octeontx2.rst:169--202.
> 
> Tune markup and formatting for better presentation in the HTML view.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> v1 -> v2: minor stylistic tuning as suggested by Randy
> 
> applies cleanly on current master (v5.11-rc2) and next-20210106
> 
> George, please ack.
> Jonathan, please pick this minor formatting clean-up patch.
> 
>  .../ethernet/marvell/octeontx2.rst            | 62 +++++++++++--------
>  1 file changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> index d3fcf536d14e..61e850460e18 100644
> --- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> +++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
