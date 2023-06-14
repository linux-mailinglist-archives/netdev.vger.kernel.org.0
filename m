Return-Path: <netdev+bounces-10704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A93B472FE02
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FE98281091
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178978F4D;
	Wed, 14 Jun 2023 12:12:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCE37476;
	Wed, 14 Jun 2023 12:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6588C433C0;
	Wed, 14 Jun 2023 12:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686744730;
	bh=zHcMsKnQSNQFhkeP6Yrou3QMRDYm27B+uJXLYuqzc/4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sawNrngXNPSN7u1o4+On4EaVZ7fk4mz+duEnZKMe/olvA6CkBVAa57skWjz2sQ7iN
	 YY/N2QgaCTG0USIz/LIiM1YqFPhKENGO3n8fd/imtv2IwFE0OSfa9gWEmW4fsMQG6g
	 yY9s9TXRwCzVavBH/oATeMMszWCYtHEHQPg4N6jxZod+vT6Bg2iMM8ffIweg5GRGfs
	 vnA276Dtpe55I4bURp7BZFQBr5PBzwLfPyUoQBDcwboSSnkrdx07P01vIGfLhwdI89
	 saZ8NV/uFSx04lUsiYaX5TZbQ80LwPdkom9hkT0yDTG3cT1mC0EgMrubgggOw5PO6i
	 /ditZPf3ETaXA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 3536DBBEB6A; Wed, 14 Jun 2023 14:11:01 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
Subject: Re: Closing down the wireless trees for a summer break?
In-Reply-To: <c7c9418bcd5ac1035a007d336004eff48994dde7.camel@sipsolutions.net>
References: <87y1kncuh4.fsf@kernel.org> <871qifxm9b.fsf@toke.dk>
 <20230613112834.7df36e95@kernel.org>
 <ba933d6e3d360298e400196371e37735aef3b1eb.camel@sipsolutions.net>
 <20230613195136.6815df9b@kernel.org>
 <c7c9418bcd5ac1035a007d336004eff48994dde7.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 14 Jun 2023 14:11:01 +0200
Message-ID: <871qiekzvu.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Johannes Berg <johannes@sipsolutions.net> writes:

> Toke usually reviews patches for ath9k but then asks Kalle (via
> assigning in patchwork) to apply them.

As for this bit I suppose we can either agree that I do the patchwork
delegation to someone else during the break (who?), or that y'all on the
net maintainer side just apply any patches that I ACK on the list
without further action on my part. No strong preference, whatever works
best for you, Jakub :)

-Toke

