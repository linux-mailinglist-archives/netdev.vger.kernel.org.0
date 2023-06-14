Return-Path: <netdev+bounces-10765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E85BE7302E5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D10EA1C20D66
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A2CDF52;
	Wed, 14 Jun 2023 15:07:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595EA8460;
	Wed, 14 Jun 2023 15:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEF3C433C8;
	Wed, 14 Jun 2023 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686755267;
	bh=DZVt3kjkY559qmGtC1/RX3/D7SfDAvHLLqPhyTY1QmA=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=S0DbZIZOBOXRCc06oyYCeQYpKD+DnXYWEuQdGdASou6YlbntDI8b4Z1opHgZqzZqD
	 mEV9TTwkfySp1umPpHu9zAFjujdqQHDJyifbB1veIiy+WnSNS+ZrQY7hkHVkNVT5Xy
	 kXENE9vNc4BM4gmvbT83CVxXTbUyZcFcSfZXz82Mu9DzdPNf/frQvKquur3qejhzJV
	 bvKqx+bb8/cOoYeqKGe6r4TvmBJ/mNYV8thqm7KGDxit1f2gqe7Nj5SEPmXOyPHYv7
	 9vjQKA2MrhRNAhivyt5zDsn09DRJw1vSM3CeiwEz0tmgti8KvGVtgGxLrO6zgRx6SZ
	 S65HJI0fN39MQ==
From: Kalle Valo <kvalo@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jakub Kicinski <kuba@kernel.org>,  Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8?=
 =?utf-8?Q?rgensen?= <toke@kernel.org>,  linux-wireless@vger.kernel.org,
  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,
  regressions@lists.linux.dev
Subject: Re: Closing down the wireless trees for a summer break?
References: <87y1kncuh4.fsf@kernel.org> <871qifxm9b.fsf@toke.dk>
	<20230613112834.7df36e95@kernel.org>
	<ba933d6e3d360298e400196371e37735aef3b1eb.camel@sipsolutions.net>
	<20230613195136.6815df9b@kernel.org>
	<c7c9418bcd5ac1035a007d336004eff48994dde7.camel@sipsolutions.net>
Date: Wed, 14 Jun 2023 18:07:43 +0300
In-Reply-To: <c7c9418bcd5ac1035a007d336004eff48994dde7.camel@sipsolutions.net>
	(Johannes Berg's message of "Wed, 14 Jun 2023 11:56:16 +0200")
Message-ID: <87a5x2ccao.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2023-06-13 at 19:51 -0700, Jakub Kicinski wrote:
>
>> On Tue, 13 Jun 2023 22:00:35 +0200 Johannes Berg wrote:
>> > On Tue, 2023-06-13 at 11:28 -0700, Jakub Kicinski wrote:
>> > > On Tue, 13 Jun 2023 20:14:40 +0200 Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:=20=20
>> > > > I think this sounds reasonable, and I applaud the effort to take s=
ome
>> > > > time off during the summer :)
>> > > >=20
>> > > > One question that comes to mind is how would this work for patchwo=
rk?
>> > > > Would we keep using the wireless patchwork instance for the patches
>> > > > going to -net in that period, or will there be some other process =
for
>> > > > this? I realise the setup we have for ath9k is a bit special in th=
is
>> > > > regard with the ack-on-list+delegation, so I'm obviously mostly
>> > > > interested in what to do about that... :)=20=20
>> > >=20
>> > > Whatever's easiest :) It's probably a good idea for Kalle to write
>> > > down all the local rules and customs and share those with us.
>> >=20
>> > While that's probably a good idea regardless, I'd think that patchwork
>> > doesn't really matter that much - we'll have some catching up to do
>> > anyway after the vacations, so looking through patchwork etc. would be
>> > perfectly acceptable. Worst case we'd notice when a patch doesn't appl=
y,
>> > right? :)
>>=20
>> Right, I meant it more in terms of patch flow. Is looking at which
>> drivers have a tree specified in MAINTAINERS enough to know what
>> should be applied directly?
>
> Oh, right. Not really sure how well that all is reflected in
> MAINTAINERS.

Now that I sent some updates, the separate driver specific trees should
be pretty well documented in MAINTAINERS:

https://patchwork.kernel.org/project/linux-wireless/list/?series=3D757173

But do let me know if I missed something.

> So Gregory usually handles patches for iwlwifi, but he'll _also_ be on
> vacation around a similar time frame.
>
> Toke usually reviews patches for ath9k but then asks Kalle (via
> assigning in patchwork) to apply them.
>
> Felix usually picks up patches for mediatek drivers (unless specifically
> asking Kalle for individual ones) and then sends a pull request.
>
> For the stack (all the bits we have under net/) that's just on me,
> normally.
>
> I think that's it? But I guess Kalle will have more comments.

And for drivers/net/wireless/ath/ I have my ath.git tree for which I
take all patches for drivers under that directory. (BTW I might be
updating my ath.git tree some time during summer, but no promises. I
will be mostly offline and not even checking email.)

But do note that above is _only_ for -next patches. For patches going to
-rc releases we apply the patches directly to wireless, no other trees
are involved. My proposal was that net maintainers would take only fixes
for -rc releases, my guess from history is that it would be maximum of
10-15 patches. And once me and Johannes are back we would sort out -next
patches before the merge window. But of course you guys can do whatever
you think is best :)

>> > Wrt. ath9k patches I guess "delegate in patchwork" won't work anymore,
>> > but "resend to netdev" or something perhaps?
>>=20
>> We can watch PW state and apply from linux-wireless, I reckon.
>> That said I don't know how you use delegation :)
>
> We have auto-delegation set up for this, except iwlwifi is on me right
> now for the upstream, and I just delegate other incoming patches to
> Gregory.

Auto-delegation is awesome, it helps our workflow quite a lot. Though it's =
not
perfect and some of the patches will not get delegated automatically. So
I periodically check this link if there are patches needing for manual
delegation:

https://patchwork.kernel.org/project/linux-wireless/list/?series=3D&submitt=
er=3D&state=3D&q=3D&archive=3D&delegate=3DNobody

As an example, right now I see one pull request and one patch:

https://patchwork.kernel.org/project/linux-wireless/patch/20230614075502.11=
765-1-johannes@sipsolutions.net/
https://patchwork.kernel.org/project/linux-wireless/patch/20230612130256.45=
72-5-linyunsheng@huawei.com/

It's a minor nuisance so I haven't bothered to even report it to
patchwork project.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

