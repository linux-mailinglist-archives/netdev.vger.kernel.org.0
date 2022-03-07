Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6E4D04E9
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244378AbiCGRHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbiCGRHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:07:50 -0500
Received: from outgoing-stata.csail.mit.edu (outgoing-stata.csail.mit.edu [128.30.2.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7ED567C795;
        Mon,  7 Mar 2022 09:06:52 -0800 (PST)
Received: from [117.192.122.233] (helo=srivatsab-a02.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1nRGog-000Ti1-FU; Mon, 07 Mar 2022 12:06:38 -0500
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        tglx@linutronix.de, bp@alien8.de
Cc:     linux-graphics-maintainer@vmware.com, Deep Shah <sdeep@vmware.com>,
        Joe Perches <joe@perches.com>, linux-rdma@vger.kernel.org,
        Ronak Doshi <doshir@vmware.com>, Nadav Amit <namit@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Zack Rusin <zackr@vmware.com>, linux-input@vger.kernel.org,
        Vivek Thampi <vithampi@vmware.com>, linux-scsi@vger.kernel.org,
        Vishal Bhakta <vbhakta@vmware.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, rostedt@goodmis.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
References: <164574138686.654750.10250173565414769119.stgit@csail.mit.edu>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v5 0/3] Update VMware maintainer entries
Message-ID: <b0a49148-de03-a591-0849-6bb7d8e8b659@csail.mit.edu>
Date:   Mon, 7 Mar 2022 22:36:23 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <164574138686.654750.10250173565414769119.stgit@csail.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+virtualization list, which I forgot to CC when posting v5]

Hi Thomas, other x86 maintainers,

On 2/25/22 2:23 PM, Srivatsa S. Bhat wrote:
> This series updates a few maintainer entries for VMware-maintained
> subsystems and cleans up references to VMware's private mailing lists
> to make it clear that they are effectively email-aliases to reach out
> to reviewers.
> 

Since this patchset got ACKs from the relevant subsystem maintainers,
would you mind taking them through your tree, if this looks good to
you too?

Thank you!

Regards,
Srivatsa

> Changes from v4->v5:
> - Add Alexey as reviewer for paravirt ops.
> 
> Changes from v3->v4:
> - Remove Cc: stable@vger.kernel.org from patches 1 and 2.
> 
> Changes from v1->v3:
> - Add Zack as the named maintainer for vmmouse driver
> - Use R: to denote email-aliases for VMware reviewers
> 
> Regards,
> Srivatsa
> VMware Photon OS
> 
> ---
> 
> Srivatsa S. Bhat (VMware) (3):
>       MAINTAINERS: Update maintainers for paravirt ops and VMware hypervisor interface
>       MAINTAINERS: Add Zack as maintainer of vmmouse driver
>       MAINTAINERS: Mark VMware mailing list entries as email aliases
> 
> 
>  MAINTAINERS | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 


