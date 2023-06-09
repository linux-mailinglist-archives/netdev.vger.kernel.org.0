Return-Path: <netdev+bounces-9507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B057297D9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AD8280F2B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D058914ABA;
	Fri,  9 Jun 2023 11:09:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EB7DDA8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9307AC433EF;
	Fri,  9 Jun 2023 11:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686308962;
	bh=UtE2ojfq4pTGAnMSeMjcwz21FgB8hzLm4sDSgC0mL/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i27069RQ6hDxiL+hM97+VFg3JTP2OqE8fBDTccIS9s0C6/FGfkYrhRkdNPlkr0LhV
	 T4LdK8B1KrotH05e15zDckSyEuhmSMSzu/bzb9OIKKhj2miL9xfBHQUDMcA5h68GPv
	 siaiD83SQTwMU8OcYrgFZUNbNhVRRqEc880q+2qs=
Date: Fri, 9 Jun 2023 13:09:19 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: George Valkov <gvalkov@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Foster Snowhill <forst@pen.gy>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	patchwork-bot+netdevbpf@kernel.org,
	Simon Horman <simon.horman@corigine.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	linux-usb <linux-usb@vger.kernel.org>,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/4] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Message-ID: <2023060907-matted-dorsal-af5e@gregkh>
References: <20230607135702.32679-1-forst@pen.gy>
 <168630302068.8448.16788889957368567496.git-patchwork-notify@kernel.org>
 <07CBE5ED-2569-450D-975A-64B5670D6928@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07CBE5ED-2569-450D-975A-64B5670D6928@gmail.com>

On Fri, Jun 09, 2023 at 01:42:09PM +0300, George Valkov wrote:
> Thank you David!
> 
> Can you please also backport the patch-series to Linux kernel 5.15, which is in use by the OpenWRT project! The patches apply cleanly.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

