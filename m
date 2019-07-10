Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E0648A5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfGJOvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfGJOvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 10:51:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10BFD20645;
        Wed, 10 Jul 2019 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770274;
        bh=p7Jhjq6FO2XopPND8g78jDlqt/nU529GHfEQLxCVxmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y3hfs2UIuCn3gZLUiUGJX2cT6kqSe2EziKkuF3h+9PVpLG6CD11qX3VlJGq0JDFRe
         kscKHJKoSr6ylpXIcYOFqWUdqsR6uLoFrVJk37NTLJqxeXQBKwmx+fIBFq2bqwV+kV
         AS1xUwy47BU6795UGfu21t/U9kk9WUEYrsch3MnE=
Date:   Wed, 10 Jul 2019 10:51:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 14/60] mwifiex: Abort at too short BSS
 descriptor element
Message-ID: <20190710145112.GX10104@sasha-vm>
References: <20190627003616.20767-1-sashal@kernel.org>
 <20190627003616.20767-14-sashal@kernel.org>
 <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 03:58:49PM -0700, Brian Norris wrote:
>On Wed, Jun 26, 2019 at 5:49 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit 685c9b7750bfacd6fc1db50d86579980593b7869 ]
>>
>> Currently mwifiex_update_bss_desc_with_ie() implicitly assumes that
>> the source descriptor entries contain the enough size for each type
>> and performs copying without checking the source size.  This may lead
>> to read over boundary.
>>
>> Fix this by putting the source size check in appropriate places.
>>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>For the record, this fixup is still aiming for 5.2, correcting some
>potential mistakes in this patch:
>
>63d7ef36103d mwifiex: Don't abort on small, spec-compliant vendor IEs
>
>So you might want to hold off a bit, and grab them both.

I see that 63d7ef36103d didn't make it into 5.2, so I'll just drop this
for now.

--
Thanks,
Sasha
