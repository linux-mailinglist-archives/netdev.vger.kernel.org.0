Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833913672F7
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbhDUS6Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Apr 2021 14:58:16 -0400
Received: from mailout00.webspace-verkauf.com ([37.218.254.21]:60990 "EHLO
        mailout00.webspace-verkauf.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234093AbhDUS6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:58:16 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2021 14:58:15 EDT
Received: from c5.webspace-verkauf.de (c5.webspace-verkauf.de [37.218.254.105])
        by mailout00.webspace-verkauf.com (Postfix) with ESMTPS id 2C9C14004FD;
        Wed, 21 Apr 2021 20:50:33 +0200 (CEST)
Received: from [192.168.178.20] (pd9fe9a79.dip0.t-ipconnect.de [217.254.154.121])
        by c5.webspace-verkauf.de (Postfix) with ESMTPSA id 87A7A1B7B922;
        Wed, 21 Apr 2021 20:50:32 +0200 (CEST)
To:     gregkh@linuxfoundation.org
Cc:     a.shelat@northeastern.edu, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        dwysocha@redhat.com, kuba@kernel.org, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, pakki001@umn.edu,
        sudipm.mukherjee@gmail.com, trondmy@hammerspace.com
References: <YIAtwtOpy/emQWr2@kroah.com>
From:   Alexander Grund <alex@grundis.de>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <821177ec-dba0-e411-3818-546225511a00@grundis.de>
Date:   Wed, 21 Apr 2021 20:50:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIAtwtOpy/emQWr2@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Language: de-DE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > Below is the list that didn't do a simple "revert" that I need to look
 > at. I was going to have my interns look into this, there's no need to
 > bother busy maintainers with it unless you really want to, as I can't
 > tell anyone what to work on :)

I'm not involved or affliated with the group or the kernel, but I'd like to make a suggestion:
Do not revert umn.edu patches unconditionally.
See below:

According to the paper:
 > We submit the three patches using a randomGmail account to the Linux community andseek their feedback

So while their behaviour regarding this practice may have been bad, I'd give them the benefit of doubt that they didn't want to actually introduce 
a bug.
I.e. what they wrote:

> we immediately notify themaintainers of the introduced UAF and request them to notgo ahead to apply the patch.
 > At the same time, we point out the correct fixing of the bug and provide our correct patch.
 > [...] All the UAF-introducing patches stayed only in the emailexchanges, without even becoming a Git commit in Linuxbranches

TLDR:
- The faulty patches were NOT from umn.edu accounts but from a gmail account
- Only the corrected patches should have made it to the branches

So while I would at least double-check that the last point is actually true, I believe reverting all umn.edu patches is wrong and actually (re-)introduces vulnerabilities or bugs which have been legitimately fixed (at least in good faith)
And especially if the reverts do not apply cleanly on the current HEADs I 
think you might be wasting a lot of work/time, too.

And yes, this aftermath makes it even worse what they did and excluding them from future contributions may make sense.
But maybe reverting EVERYTHING is a bit to much here, especially if that doesn't even include the faulty stuff (assuming they are not plain lying in their paper, which I really doubt they would)

Alex


