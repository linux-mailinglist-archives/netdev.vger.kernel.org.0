Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E306631CD
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 21:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAIUre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 15:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjAIUqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 15:46:48 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 Jan 2023 12:46:46 PST
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B8E72D23
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 12:46:45 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id e360dcfb
        for <netdev@vger.kernel.org>;
        Mon, 9 Jan 2023 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:subject:message-id:mime-version:content-type; s=
        default; bh=hOUk1VjhC9OpxHFz7UBF80CkhWw=; b=Op70U1oui1B7b6JQkb8q
        MZqQ+FKVAY8ZQvDRkqnU9Z8JcIKbInKz0scJO+HBg0IGMamfGGe0fc4BAy3qkMGX
        4nHfAZcemoIzEWkpZQmHVy9soPCzjlWBnL4ZX4FDP2JE+pijbUoPCtkcezMqa7X3
        lHSjuJYl9eJP+rEol6bI0ns=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:subject:message-id:mime-version:content-type; q=dns; s=
        default; b=sdvirR2ZARt2h6FjiuDRdlySoMKVZ6LAg+frkHUxLnPlknum2RByX
        3o38lzNBkRfvPxWwraKWFr1/oZAgsZcjEEo7HDgPhYRVN05CjBqtFog0TFH3x+FQ
        6i4Rpg86ghNsUyyynOprYEjZD5Az8ADm5c5r9R+yxKxKvlcnHE0d6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1673296804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=v9L6UidFTW94J9on2sqAsil8z3NJ7xmjzh5bQ+NHtro=;
        b=DEFikmJBtv7V1yijQ4cdFAQeJ0Sn0N6Q6rlFlGtfs+hwATbJ1XxqfCa/WV3PW+C/HaUGAE
        oHuQ1fHih38CQ6nEFh6zDYtb6ysx+whFB9CcpgU/9dD+6c9jOtPqju9wrflhL0OL7bX6u3
        bcLRg5vFAcR+WMNcZw6TXMypdkI4R7I=
Received: from dfj (host-87-9-235-24.retail.telecomitalia.it [87.9.235.24])
        by ziongate (OpenSMTPD) with ESMTPSA id 641b0fee (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 9 Jan 2023 20:40:03 +0000 (UTC)
Date:   Mon, 9 Jan 2023 21:40:06 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     netdev@vger.kernel.org
Subject: mv88e6321, dual cpu port
Message-ID: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

using kernel 5.4.70,
just looking for confirmation this layout
can work:

    eth0 -> cpu port (port5, mii)  bridging port3 and 4
    eth1 -> cpu port (port6, rgmii)  bridging port0, 1, 2

My devicetree actaully defines 2 cpu ports, it seems
to work, but please let me know if you see any
possible issue.

Regards,
Angelo Dureghello
