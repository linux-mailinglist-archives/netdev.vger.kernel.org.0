Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C242D4D31DB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiCIPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiCIPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:35:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BAB149BAE
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 07:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30B3B8216D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 15:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B3EC340E8;
        Wed,  9 Mar 2022 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646840062;
        bh=7yYiJI5tqzO8Kyu81+cSirWwndKnfdH9FH26XEoqMOw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=E/pr5QFUcxCsokcap8XJBi2mkc23k/1EQe7zKboV7WJgvxy/l4bUbYAKCRBiSZUC0
         TzSJhlQtDO6PcqH+R7hAyqrSMiMGgB6cjemOs3pP7jtz2YkxfFnGUyQRDq9puGb7pD
         EeKbCC7Q4W1zaOXTV6ryEO5Yss+ACnr/60j7/tuuESL8CRIOElUbU58036PRQYFUPX
         HqTmAlQygknQZ6+nUgpgxg7MPBFJ78dD+QMhw9qhEaI2SVkfW1kT1zURpJJ66LiDDU
         UA/yzdl2QIngp1JxLGFeZcZn0W6poKTiE6517YE+abf8vM+jDXugvQy//pugUPs88c
         WZUPjtuYWEGPg==
Message-ID: <4a607084-7ade-0dbc-5b0a-a7eb02b899f2@kernel.org>
Date:   Wed, 9 Mar 2022 08:34:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v4 0/4] vdpa tool enhancements
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, lulu@redhat.com, si-wei.liu@oracle.com,
        parav@nvidia.com
References: <20220302065444.138615-1-elic@nvidia.com>
 <1755f8e1-358b-b515-c51c-c2aa7bd0dd28@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <1755f8e1-358b-b515-c51c-c2aa7bd0dd28@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 1:07 AM, Jason Wang wrote:
> 
> 在 2022/3/2 下午2:54, Eli Cohen 写道:
>> Hi Stephen,
>>
>> this is a resend of v3 which omitted you and netdev from the recepient
>> list. I added a few "acked-by" and called it v4.
>>
>> The following four patch series enhances vdpa to show negotiated
>> features for a vdpa device, max features for a management device and
>> allows to configure max number of virtqueue pairs.
>>
>> v3->v4:
>> Resend the patches with added "Acked-by" to the right mailing list.
> 
> 
> Hello maintainers:
> 
> Any comment on the series? We want to have this for the next RHEL release.
> 

I was no cc'ed on the patches; you will need to re-send.
