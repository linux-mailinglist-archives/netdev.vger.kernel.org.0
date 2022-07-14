Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA05D574961
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiGNJpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiGNJpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:45:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303C22982B;
        Thu, 14 Jul 2022 02:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=07oUEKHSzm+NLpMZQXlziUA9naI9SGuvr9Rc9aLt8XE=;
        t=1657791912; x=1659001512; b=V/fjWiVYh2fLZwviFs5feSv7Uwyq5bSbkmUBMxq+4k5s2Ur
        7MO3xTQuIm+pWTpTcSo3r3MTtDdwrTvhhKhoimhMy1D4aoB1p4Jkc8WAM1PaTIeCQ/MYdl4iX29Wc
        t+O4zy2lnmzgQw9yBynt3AamfQExS/5QMfCpTIIDkqRxAIitZLJ+8PS4kBOupD9xmLLLeljVBvT1k
        K0ZteVPCYrLUNNs9SsV01Kqx8Y/17K1Q0kVk0kziRDhTp0AeJItX2VGBn2jzo9slCpycEVhkVrrCZ
        FguVmzVX9t8e489IIfDzCb5WEC0Ay3Zn9QA5V1GhHQp8Y9/ZkOb2BGjFNRlFgyRQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBvP5-00Fa1N-Ix;
        Thu, 14 Jul 2022 11:45:03 +0200
Message-ID: <7cebf20083d2464e5f1467a406cda583ae2750a0.camel@sipsolutions.net>
Subject: Re: [PATCH] p54: add missing parentheses in p54_flush()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Date:   Thu, 14 Jul 2022 11:45:02 +0200
In-Reply-To: <20220714091741.90747-1-subkhankulov@ispras.ru>
References: <20220714091741.90747-1-subkhankulov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-14 at 12:17 +0300, Rustam Subkhankulov wrote:
> The assignment of the value to the variable total in the loop
> condition must be enclosed in additional parentheses, since otherwise,
> in accordance with the precedence of the operators, the conjunction
> will be performed first, and only then the assignment.
>=20
> Due to this error, a warning later in the function after the loop may
> not occur in the situation when it should.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Fixes: d3466830c165 ("p54: move under intersil vendor directory")
>=20

That fixes can't be right, it just moved the code.

johannes
