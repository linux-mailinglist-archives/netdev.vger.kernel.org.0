Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA536BA566
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 04:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCODAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 23:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCODAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 23:00:36 -0400
X-Greylist: delayed 341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 20:00:34 PDT
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [IPv6:2001:41d0:1004:224b::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C444AFF3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 20:00:34 -0700 (PDT)
Date:   Tue, 14 Mar 2023 19:54:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678848891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TiPNSFU14T5mNrXyfZ7BWdFbhOsFfike4nxA4eG3ifY=;
        b=C/s3EFwPTARUrC27Irr8MoQ8X+GriwefE6AtOALzhFTTeyrOiWnWs+s4ZFeBZvYWCYZlji
        kcWEg7GX6sMIx3Gkf6v8iKqAAeL5miP7Z2+yucnGoq0gfYShJ5o23UbsbT1GMrrr2G60I5
        XuV3qbY1/m6YQ2m5FMA/Kb+jNUymu/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/7] mm/slob: remove slob.c
Message-ID: <ZBEzdkADd6vCjw78@P9FQF9L96D>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-7-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-7-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:32:08AM +0100, Vlastimil Babka wrote:
> Remove the SLOB implementation.
> 
> RIP SLOB allocator (2006 - 2023)
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
