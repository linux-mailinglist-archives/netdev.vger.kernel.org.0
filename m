Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFB16C5AA3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjCVXj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCVXjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:39:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BF031E2F;
        Wed, 22 Mar 2023 16:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=8daXEd6MaaPrLdJgfUmbT6IH8egyXiyw/7687lpnypg=; b=vTeOT5/1zVXkmCGEQaOuIc0Kgq
        O7/JSGG4x9gVDcym45j6CpYtb7jCEkOydNTj4RZ3Lr/Jzhsqs0VDHIt/Gws67y4ZASciZ4hvOh622
        3BaXdMKTQXxX3yBM5Dn3xJidbBhBHkEpdsG18NAqzD4W3bAtDMZGl4F20E3nA6/EFyhzRh2cwEPi4
        DHGVePGyUgAwFVzWtBnp4DwZk8AVEZkH1kFSQtQ/3g55EZtOFdEsxx3yWOqdZSBx+qwiyvX1HP3YQ
        OiosKtoKpox009LkcdZD6LWy1aVEejWdiW6+Ed7rGI7AJF0dNAkLoNOaZk57w2066C7KRmiq9ow9W
        E7RChpoQ==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pf82g-000An5-1T;
        Wed, 22 Mar 2023 23:38:54 +0000
Message-ID: <af2e9958-d624-d5fc-9403-a082ff15df9a@infradead.org>
Date:   Wed, 22 Mar 2023 16:38:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] docs: netdev: add note about Changes Requested
 and revising commit messages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sean.anderson@seco.com, corbet@lwn.net, linux-doc@vger.kernel.org
References: <20230322231202.265835-1-kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230322231202.265835-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/23 16:12, Jakub Kicinski wrote:
> One of the most commonly asked questions is "I answered all questions
> and don't need to make any code changes, why was the patch not applied".
> Document our time honored tradition of asking people to repost with
> improved commit messages, to record the answers to reviewer questions.
> 
> Take this opportunity to also recommend a change log format.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I couldn't come up with a real example of the commit message.
> LMK if the fake one is too silly :)

FWIW I like it.

> 
> CC: sean.anderson@seco.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/process/maintainer-netdev.rst | 29 +++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
> index 4a75686d35ab..4d109d92f40d 100644
> --- a/Documentation/process/maintainer-netdev.rst
> +++ b/Documentation/process/maintainer-netdev.rst
> @@ -109,6 +109,8 @@ Finally, the vX.Y gets released, and the whole cycle starts over.
>  netdev patch review
>  -------------------
>  
> +.. _patch_status:
> +
>  Patch status
>  ~~~~~~~~~~~~
>  
> @@ -143,6 +145,33 @@ Asking the maintainer for status updates on your
>  patch is a good way to ensure your patch is ignored or pushed to the
>  bottom of the priority list.
>  
> +Changes requested
> +~~~~~~~~~~~~~~~~~
> +
> +Patches :ref:`marked<patch_status>` as ``Changes Requested`` need
> +to be revised. The new version should come with a change log,
> +preferably including links to previous postings, for example::
> +
> +  [PATCH net-next v3] net: make cows go moo
> +
> +  Even users who don't drink milk appreciate hearing the cows go "moo".
> +
> +  The amount of mooing will depend on packet rate so should match
> +  the diurnal cycle quite well.
> +
> +  Signed-of-by: Joe Defarmer <joe@barn.org>
> +  ---
> +  v3:
> +    - add a note about time-of-day mooing fluctuation to the commit message
> +  v2: https://lore.kernel.org/netdev/123themessageid@barn.org/
> +    - fix missing argument in kernel doc for netif_is_bovine()
> +    - fix memory leak in netdev_register_cow()
> +  v1: https://lore.kernel.org/netdev/456getstheclicks@barn.org/
> +
> +Commit message should be revised to answer any questions reviewers

The commit message should be

> +had to ask in previous discussions. Occasionally the update of

asked in previous discussions.

> +the commit message will be the only change in the new version.
> +
>  Partial resends
>  ~~~~~~~~~~~~~~~
>  

-- 
~Randy
