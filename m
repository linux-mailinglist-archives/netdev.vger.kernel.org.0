Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1239189A5D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 12:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCRLQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 07:16:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:52250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgCRLQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 07:16:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE580B25F;
        Wed, 18 Mar 2020 11:16:25 +0000 (UTC)
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for
 xen-netfront
To:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, wei.liu@kernel.org, paul@xen.org
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com>
Date:   Wed, 18 Mar 2020 12:16:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.03.20 14:09, Denis Kirjanov wrote:
> The patch adds a basic XDP processing to xen-netfront driver.
> 
> We ran an XDP program for an RX response received from netback
> driver. Also we request xen-netback to adjust data offset for
> bpf_xdp_adjust_head() header space for custom headers.

This is in no way a "verbose patch descriprion".

I'm missing:

- Why are you doing this. "Add XDP support" is not enough, for such
   a change I'd like to see some performance numbers to get an idea
   of the improvement to expect, or which additional functionality
   for the user is available.

- A short description for me as a Xen maintainer with only basic
   networking know-how, what XDP programs are about (a link to some
   more detailed doc is enough, of course) and how the interface
   is working (especially for switching between XDP mode and normal
   SKB processing).

- A proper description of the netfront/netback communication when
   enabling or disabling XDP mode (who is doing what, is silencing
   of the virtual adapter required, ...).

- Reasoning why the suggested changes of frontend and backend state
   are no problem for special cases like hot-remove of an interface or
   live migration or suspend of the guest.

Finally I'd like to ask you to split up the patch into a netfront and
a netback one.


Juergen
