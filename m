Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FF63CC6AB
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 00:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhGQWjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 18:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhGQWjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 18:39:41 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39BC061762
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=jw5jegpVzEx6W0IuTDo8ewoGY57Mg8QE/qYuKyKZD9Q=; b=qWYhr5PpjrrtUpue4cdgCyppBy
        q7XrI+YaB8tvOCE5sKh/b3xoRihID/lBJRw4tfMwh3YC6NJVTPDo8nsUxcIYzeney109qu5dXgWtN
        RzX/Wjh63aPdu33oAsYnUDYCaBnVLyuGNi+Qe0TADvQN+gJPc375dqh3694+bNrLsJCW9Xv2yilVf
        V0aAwWDXauxvJNhgX2TNFeNFM6CxPnVmE+bxnGiuvICl04n0OhSHDeY+ufwk3ZxqG8L1IzEE7w6Y1
        eGwWbVp/DeTbTks2hUlklndb0zFvWJGSYCp0Y4caVteekwb8Zg8AWX06zJRPeDE0wTBg6jOO5yXlR
        OX+nqMag==;
Received: from [2602:306:c5a2:a380:20fe:9687:9f1f:1f76]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4sv9-000jV5-IN; Sat, 17 Jul 2021 22:36:31 +0000
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH v3 1/2] net/ps3_gelic: Add gelic_descr structures
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1625976141.git.geoff@infradead.org>
 <e63dc0564b7c6e4f699c306bf36feb4bd9c30f26.1625976141.git.geoff@infradead.org>
 <20210711160330.Horde.YmbaUrNaGLYM4ADZvVr_gA1@messagerie.c-s.fr>
Message-ID: <c0a78c3f-0934-bc29-147d-0b3e14efb70b@infradead.org>
Date:   Sat, 17 Jul 2021 15:36:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210711160330.Horde.YmbaUrNaGLYM4ADZvVr_gA1@messagerie.c-s.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On 7/11/21 7:03 AM, Christophe Leroy wrote:
> 
> Your patch has a lot of cosmetic changes. Several of them are just wrong. The other ones belong to another patch. This patch should focus only on the changes it targets.
> 
> Your patch is way too big and addresses several different topics. Should be split in several patches.
> 
> I suggest you run checkpatch.pl --strict on your patch
> 

Thanks for the review.  I'll create a follow up patch set with
your comments in mind.

-Geoff
