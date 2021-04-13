Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB535E272
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344583AbhDMPPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242392AbhDMPPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:15:14 -0400
Received: from blyat.fensystems.co.uk (blyat.fensystems.co.uk [IPv6:2a05:d018:a4d:6403:2dda:8093:274f:d185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE2EC061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 08:14:53 -0700 (PDT)
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id DEBBC4427E;
        Tue, 13 Apr 2021 15:14:46 +0000 (UTC)
Subject: Re: xen-netback hotplug-status regression bug
To:     paul@xen.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>
References: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
 <f469cdee-f97e-da3f-bcab-0be9ed8cd836@xen.org>
 <58ccc3b7-9ccb-b9bf-84e7-4a023ccb5c56@ipxe.org>
 <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
From:   Michael Brown <mcb30@ipxe.org>
Message-ID: <d452efde-a2cc-ee5e-bea8-a34e657e2f02@ipxe.org>
Date:   Tue, 13 Apr 2021 16:14:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        blyat.fensystems.co.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2021 11:55, Paul Durrant wrote:
> Ok, so it sound like this was probably my misunderstanding of xenstore 
> semantics in the first place (although I'm sure I remember watch 
> registration failing for non-existent nodes at some point in the past... 
> that may have been with a non-upstream version of oxenstored though).
> 
> Anyway... a reasonable fix would therefore be to read the node first and 
> only register the watch if it does exist.

Thanks.  Patch coming up shortly!

Michael

