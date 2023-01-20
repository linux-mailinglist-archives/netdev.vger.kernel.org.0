Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F3E675056
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjATJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjATJMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:12:13 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524766A301;
        Fri, 20 Jan 2023 01:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yCvla1+fc/eNBxn2xeGosvesa1IuipVu5+Hu5Pgjg20=;
        t=1674205892; x=1675415492; b=vYrx+/XeZJezhGEWLt88nvw5MPFRzn4cxXOVYIMS+YZZMps
        aa7l86+Jhsim18cHl7Pmj1ryjgBakvsiWrDq6k4PAB62uhgP+2cFJBA4TqaMn9IBd8gCWCUeBocs0
        hII2Uuuyq1cCMIwe1PZI1sgMVewsqY1wvwdKt4fUj7T3Sv+e/aBWnxOs0Zx0neG09OcM7ZTuIB2UG
        ENJtzNFS6u9TUI7ekJxilgbzNYB1IkYe3kF6T+eKGEyfBPG+uiVo3Zr7tD3VgdC7ZeAo+B2NJpns/
        l5wytuMM6YHptb7uchzDlHvyVqFC49enCaP+aWN05JzKlN4Pgd5Cnkm63p7xNNoQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pInPx-007NU6-1d;
        Fri, 20 Jan 2023 10:10:37 +0100
Message-ID: <7918760462738ceded5b67322fd5ad8035215fd8.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, Bagas Sanjaya <bagasdotme@gmail.com>
Date:   Fri, 20 Jan 2023 10:10:36 +0100
In-Reply-To: <5dd6c9bf-192d-44ab-7d93-22c01cb8d64b@intel.com>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-2-kuba@kernel.org>
         <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
         <5dd6c9bf-192d-44ab-7d93-22c01cb8d64b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Thu, 2023-01-19 at 16:23 -0800, Jacob Keller wrote:
>=20
> Per op policy is important because otherwise it can become impossible to
> safely extend a new attribute to commands over multiple kernel releases.
>=20

Yeah. I think I just realised that my issues is more with the fact that
per-op policy implies per-op attribute (identifier/number/name)space,
and if you don't have that you have attribute duplication etc.

Anyway, it just feels superfluous, not really dangerous I guess :)

johannes
