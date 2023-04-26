Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C26EF771
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbjDZPGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbjDZPGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:06:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862037AAC;
        Wed, 26 Apr 2023 08:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=dJzI1wHa5Hs77g/e2Ra7+W4pHa6Ls/Aizvrowv5+dEU=;
        t=1682521556; x=1683731156; b=CrzbqLfJPs1hpI2BJiQsfvPpcDS9JkQHeqT1ET35FZwZjOl
        tnOnfzKXZhWnJl13PU7D0qs7OFW069rHAuV1yZNS/17y/qJrpgYZTix+leAscUqTW430kYvg3IeKD
        KDcHK7KLSmkIhB+1wMNGLMHVGAOb72EYhdjS0LySVjtOzUQQKK12bvrft36wwv3rD5ahc4iUXBRSu
        g2/v+XcFVNogGae1T2yMvKziI3Hs592QZacSJNL9JPasPrOztVrcHSfCuDrNh3Xo00pUpsh5hPzLh
        AhFCe8ixhvATHIRZOXT8Phz8Kwe3+SwmhyHKyp28g7A6Ju4aiRdhsT7HdWga+UsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1prgiE-009DHv-1e;
        Wed, 26 Apr 2023 17:05:42 +0200
Message-ID: <d1e8fff25b49f8ee8d3e38f7b072d6e1911759bb.camel@sipsolutions.net>
Subject: Re: [PATCH v4 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
Date:   Wed, 26 Apr 2023 17:05:41 +0200
In-Reply-To: <074cf5ed-c39d-1c16-12e7-4b14bbe0cac4@alu.unizg.hr>
References: <20230425164005.25272-1-mirsad.todorovac@alu.unizg.hr>
         <20230426064145.GE27649@unreal>
         <074cf5ed-c39d-1c16-12e7-4b14bbe0cac4@alu.unizg.hr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-26 at 16:02 +0200, Mirsad Todorovac wrote:
>=20
> That's awesome! Just to ask, do I need to send the PATCH v5 with the
> Reviewed-by: tag, or it goes automatically?
>=20

Patchwork will be pick it up automatically.

johannes
