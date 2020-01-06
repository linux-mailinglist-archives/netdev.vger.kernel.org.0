Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD3130B78
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgAFB3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:29:03 -0500
Received: from ithil.bigon.be ([163.172.57.153]:39670 "EHLO ithil.bigon.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgAFB3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 20:29:02 -0500
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2020 20:29:01 EST
Received: from localhost (localhost [IPv6:::1])
        by ithil.bigon.be (Postfix) with ESMTP id 721D31FD70
        for <netdev@vger.kernel.org>; Mon,  6 Jan 2020 02:19:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bigon.be; h=
        content-language:content-transfer-encoding:content-type
        :content-type:mime-version:user-agent:date:date:message-id
        :subject:subject:from:from:received:received; s=key1; t=
        1578273593; x=1580087994; bh=J9kLLTb89vy90BqlvQt74Ye+kBTRvzt4fuC
        fehTnrBo=; b=VwCxAPMkoQwLKgXLU1L9V2kZTMRym7HdWYYXKijgPwtCAGjxQIK
        7SjSQ9w/Hb3itrrty4S4G1eWDUqAe7OLP+rZ0pjldkrOlUK/bGWtutTjrJ53F843
        KHROeMwHUgiraRZgAnxB0Vmc/O6o4hwCCRMXJjAH1vGUmk/AvTfbKGbY=
Received: from ithil.bigon.be ([IPv6:::1])
        by localhost (ithil.bigon.be [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id o6ODaPIy7ylQ for <netdev@vger.kernel.org>;
        Mon,  6 Jan 2020 02:19:53 +0100 (CET)
Received: from [IPv6:2a02:a03f:65bc:5f00:5115:4795:a6bf:81b6] (unknown [IPv6:2a02:a03f:65bc:5f00:5115:4795:a6bf:81b6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: bigon@bigon.be)
        by ithil.bigon.be (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Mon,  6 Jan 2020 02:19:53 +0100 (CET)
To:     netdev@vger.kernel.org
From:   Laurent Bigonville <bigon@bigon.be>
Subject: Error in comment in include/uapi/linux/in6.h?
Autocrypt: addr=bigon@bigon.be; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a6e75918-9608-2de3-eea5-a18f4bdf17ec@bigon.be>
Date:   Mon, 6 Jan 2020 02:19:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Looking at the ipv6_mreq struct in include/uapi/linux/in6.h, the comment
for the ipv6mr_ifindex member says "local IPv6 address of interface",
shouldn't that be "index of the interface" or something like that? Or am
I mistaken here?

struct ipv6_mreq {
        /* IPv6 multicast address of group */
        struct in6_addr ipv6mr_multiaddr;

        /* local IPv6 address of interface */
        int             ipv6mr_ifindex;
};

BTW, the include/uapi/linux/in6.h file is not listed in the MAINTAINERS
file.

Kind regards,

Laurent Bigonville

