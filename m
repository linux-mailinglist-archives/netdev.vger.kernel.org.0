Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B185F98F1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiJJHEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiJJHEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:04:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617A3B713;
        Mon, 10 Oct 2022 00:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=QYI85im/ZNOIZ4ZdrRL8lHTe3qEFXZyIRzSFCdw6jvc=;
        t=1665385443; x=1666595043; b=ACoaLAgUhMoRc6lLYNvUVLbq7F4i+yo5eyyFArGQ6QS+KHA
        ZJZO5sZ9nuuCBda1/qshfEgPOw+S7ie3tm9v/VuKxkjEy9Xu+R1OCzmmLDxkKI5qcSVi1a7tOKqtv
        WFqOLZtg1D4LD5OGf21SHJtulOIsZNX3qVqQhT1ppfgrHm+XVAfacqy4LOFb/eq3sY9T4bHSXiL8v
        qiscIKR96QMsk3hmJs/GlPIUSXpD/9t0kKrGGyAqGcpft/lI/lrWIR2GBqtS7jQqZ6Cbitdz8LNXg
        4Yfo5+waQ6qjpEBxVbpcsPmBulMmidaJqcYNNCWuhr93mndNeIDExFT693fb+ZQw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ohmpN-002w2R-1J;
        Mon, 10 Oct 2022 09:03:53 +0200
Message-ID: <8acb94e9bd6d580f739e81e5f203cb93028adf4e.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 6.0 16/77] wifi: mac80211: fix control port
 frame addressing
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 10 Oct 2022 09:03:52 +0200
In-Reply-To: <20221009220754.1214186-16-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
         <20221009220754.1214186-16-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-10-09 at 18:06 -0400, Sasha Levin wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> [ Upstream commit a6ba64d0b187109dc252969c1fc9e2525868bd49 ]
>=20
> For an AP interface, when userspace specifieds the link ID to
> transmit the control port frame on (in particular for the
> initial 4-way-HS), due to the logic in ieee80211_build_hdr()
> for a frame transmitted from/to an MLD

FWIW, I don't mind this being backported, but it doesn't make all that
much sense since the only driver "supporting" all this MLO/MLD/link_id
stuff upstream is hwsim, and it's not really finished anyway.

johannes
