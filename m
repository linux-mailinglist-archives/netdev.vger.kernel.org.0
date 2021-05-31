Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1F939693A
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhEaVQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 17:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhEaVQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 17:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC70660231;
        Mon, 31 May 2021 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622495686;
        bh=/ocKFwsXqJNsoxcMXQC2YnnCqnhQgf5FvluVu9O+ofQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbAUBygFsyn7qZ711gsNXhex0PfwcLPQtg8lpbK/hFOmaZvk1aLPERINVscnUqjRw
         CEaRB1mNSXJPKHSnask91fqYKFLTZGLzZ4AsNVKBIpnOqitJwRkFfSrt3uUmckiaET
         +cam9F3u8e22P8euQci5VUYangv/jfmcO4ypI/WlTO2LiVSAcVH/Luc/e+6d02BaMu
         kAa/Ey0t1lqgbvdAEYRgT6lnwWUofh/lLftCjiA5TlGXC2irYj/1ya0jKZFwtXLAh+
         IIZ1UJ4Ry6HK8YyQlI3d0So8Ze8Tll00gUXUeL/de30AHFy/BrIkTcp9MjTYe6MA9L
         Mpst8li+uDZLg==
Date:   Mon, 31 May 2021 17:14:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 07/16] ath6kl: return error code in
 ath6kl_wmi_set_roam_lrssi_cmd()
Message-ID: <YLVRxE04XbJXsxPW@sashalap>
References: <20210524145130.2499829-1-sashal@kernel.org>
 <20210524145130.2499829-7-sashal@kernel.org>
 <20210531204700.GA19694@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210531204700.GA19694@amd>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 10:47:00PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Anirudh Rayabharam <mail@anirudhrb.com>
>>
>> [ Upstream commit fc6a6521556c8250e356ddc6a3f2391aa62dc976 ]
>>
>> ath6kl_wmi_cmd_send could fail, so let's return its error code
>> upstream.
>
>Something went very wrong here.
>
>Content is okay, but "upstream commit" label is wrong, pointing to
>incomplete fix that was reverted (with different content and different
>author).

Yup, what ended up happening here is that my scripts got confused by the
reverted commit and the real fix having the same subject line. I've
fixed up my scripts and this patch was dropped. Thanks!

-- 
Thanks,
Sasha
