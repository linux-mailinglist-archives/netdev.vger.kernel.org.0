Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242FB196A35
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgC2AR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:17:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgC2AR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=Fa3bvAcWB2wb2aA45+pGfJn7I/4Ukm4XnRQwee9QgLI=; b=P5Jqs2QUsvrsWxKHgs2Rghd0cM
        rl566VoXvacbFwCtGqHFgeC/DnRTT8E1dectPc3kTqOs5dHcjmgL9fpcoJEFnIGJbOQu5+KIAyFVp
        qCYoKQNEx+xirwHWwED4xWJMoVSXuskMnVFaESu5v2XLoFDFEW1l+WtDUFOJrKIWfdYFl2u0JOM2U
        PoMdVwNaBxOu4CDPNQqZyWSBXB6MQue1Z++Pmum0eoKZNpavcsRIXlqrd4QxAMb2GlWWequeRYNvV
        vn32YI2jUbAzrnhvFWFlcubtQvwTgFxQbFYXmjjHvuTdWoj38tqRPzHRAXl1dvxfGEUIaHX/usPyS
        HFCId3tQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jILeG-0004SZ-UA; Sun, 29 Mar 2020 00:17:57 +0000
Subject: Re: Latest net-next from today and mellanox driver compier error
To:     =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <e7b0e756-80f9-5f3e-86b0-f8c016c755a2@itcare.pl>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <02e83e3f-9e9a-bebe-07e4-d64e1f3aee96@infradead.org>
Date:   Sat, 28 Mar 2020 17:17:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e7b0e756-80f9-5f3e-86b0-f8c016c755a2@itcare.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 4:52 PM, Paweł Staszewski wrote:
> Hi
> 
> 
> Latest net-next kernel :
> 
> drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: error: initializer element is not constant
>   .name = region_cr_space_str,
>           ^~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: note: (near initialization for 'region_cr_space_ops.name')
> drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: error: initializer element is not constant
>   .name = region_fw_health_str,
>           ^~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: note: (near initialization for 'region_fw_health_ops.name')
>   CC      drivers/net/ethernet/mellanox/mlx5/core/en_arfs.o
>   AR      drivers/nvmem/built-in.a
> make[5]: *** [scripts/Makefile.build:268: drivers/net/ethernet/mellanox/mlx4/crdump.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
> 
> 

Patch is here:
https://lore.kernel.org/netdev/20200327210835.2576135-1-jacob.e.keller@intel.com/


-- 
~Randy

