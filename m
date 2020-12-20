Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93B32DF474
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgLTI34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:29:56 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42180 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgLTI3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 03:29:55 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 14426440581;
        Sun, 20 Dec 2020 10:29:13 +0200 (IST)
References: <ccd6e8b9f1d87b683a0759e8954d03310cb0c09f.1608052699.git.baruch@tkos.co.il>
 <20201217103517.6ac75a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] docs: netdev-FAQ: add missing underlines to questions
In-reply-to: <20201217103517.6ac75a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 20 Dec 2020 10:29:12 +0200
Message-ID: <87zh28op7r.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Dec 17 2020, Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 19:18:19 +0200 Baruch Siach wrote:
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> ---
>>  Documentation/networking/netdev-FAQ.rst | 18 +++++++++++-------
>>  1 file changed, 11 insertions(+), 7 deletions(-)
>> 
>> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
>> index 4b9ed5874d5a..4ef90fe26640 100644
>> --- a/Documentation/networking/netdev-FAQ.rst
>> +++ b/Documentation/networking/netdev-FAQ.rst
>> @@ -82,6 +82,7 @@ focus for ``net`` is on stabilization and bug fixes.
>>  Finally, the vX.Y gets released, and the whole cycle starts over.
>>  
>>  Q: So where are we now in this cycle?
>> +-------------------------------------
>>  
>>  Load the mainline (Linus) page here:
>>  
>> @@ -108,6 +109,7 @@ with.
>>  Q: I sent a patch and I'm wondering what happened to it?
>>  --------------------------------------------------------
>>  Q: How can I tell whether it got merged?
>> +----------------------------------------
>
> I think this and the following fixes should be folded into a single
> line (unless it's possible in RST for header to span multiple lines):
>
> I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
> --------------------------------------------------------------------------------------------
>
> To be honest I think we can also drop the Q: and A: prefixes now that
> we're using RST.
>
> And perhaps we can add an index of questions at the beginning of the
> the file?

Sphinx creates side bar index of the questions in the HTML version. See

  https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Other formats provide other index methods.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
