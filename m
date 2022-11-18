Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD7362FF1E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKRVFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKRVFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:05:21 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A713976DA;
        Fri, 18 Nov 2022 13:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=P6rXaBfeIINbzRWSy2AGyxu2PyTieOunm5ts0qSAvmk=;
        t=1668805520; x=1670015120; b=Rwcu1xEWim0khPiqff3ufgdDSs2XzssqGHz27HbBwqHSLMU
        T3KXiXKHJlqSDkKEgy2vUilE76Bd7EUsKBv4uuLTGsgYyGKBxlSetbMKLKHxPeUoARwgnA5DI2d7H
        AIb+ZQMnlr5N7JXQyYwLyoxDENkUxH4r9gTiQtmZdCt/HfoogHbktZW8tDe+BwOLWd2s7pDBh8ZhV
        MC6/NQ53iEU4plgmzDgT+piLGOYl/F5ZS+cb9fWCZqh+7Ecxup1ZgaAAqOw0XHC2qlE8szvS31hZ6
        wmN6TzrQbxq0OUtJev05udKet0wc/lIy6kWbL9WBVRoHUPZcy8qJExkTfX53V9Jg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ow8XQ-003CYt-07;
        Fri, 18 Nov 2022 22:04:40 +0100
Message-ID: <d4c07fa45de290f32611420e2f116d8a6e32d22a.camel@sipsolutions.net>
Subject: Re: Coverity: iwl_mvm_sec_key_add(): Memory - corruptions
From:   Johannes Berg <johannes@sipsolutions.net>
To:     coverity-bot <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Petr Stourac <pstourac@redhat.com>,
        linux-kernel@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Errera <nathan.errera@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        netdev@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Abhishek Naik <abhishek.naik@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Ayala Beker <ayala.beker@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        Sriram R <quic_srirrama@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        Mike Golant <michael.golant@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Fri, 18 Nov 2022 22:04:38 +0100
In-Reply-To: <202211180854.CD96D54D36@keescook>
References: <202211180854.CD96D54D36@keescook>
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

On Fri, 2022-11-18 at 08:54 -0800, coverity-bot wrote:
>=20
> *** CID 1527370:  Memory - corruptions  (OVERRUN)
> drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c:123 in iwl_mvm_sec_key_a=
dd()
> 117
> 118     	if (WARN_ON(keyconf->keylen > sizeof(cmd.u.add.key)))
> 119     		return -EINVAL;
> 120
> 121     	if (keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
> 122     	    keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_WEP104)
> vvv     CID 1527370:  Memory - corruptions  (OVERRUN)
> vvv     Overrunning buffer pointed to by "cmd.u.add.key + 3" of 32 bytes =
by passing it to a function which accesses it at byte offset 34 using argum=
ent "keyconf->keylen" (which evaluates to 32). [Note: The source code imple=
mentation of the function has been overridden by a builtin model.]
> 123     		memcpy(cmd.u.add.key + IWL_SEC_WEP_KEY_OFFSET, keyconf->key,
> 124     		       keyconf->keylen);
> 125     	else
> 126     		memcpy(cmd.u.add.key, keyconf->key, keyconf->keylen);
> 127
> 128     	if (keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
>=20
> If this is a false positive, please let us know so we can mark it as
> such, or teach the Coverity rules to be smarter. If not, please make
> sure fixes get into linux-next. :) For patches fixing this, please
> include these lines (but double-check the "Fixes" first):
>=20

Well, I don't think you can teach coverity this easily, but the
WARN_ON() check there is not really meant to protect this - WEP keys
must have a length of either 5 or 13 bytes (40 or 104 bits!).

So there's no issue here, but I'm not surprised that coverity wouldn't
be able to figure that out through the stack.

johannes
