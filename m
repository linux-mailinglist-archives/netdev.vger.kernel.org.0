Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4E2AF380
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKKO1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKO1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:27:20 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90DC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:27:20 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d9so2358264oib.3
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=tJNevqO0XjK36FmENHY936OAEeTL8r5JxlA7yFe17JA=;
        b=shGm7xW/7s3pRFZ1eb2pCLqF9cmc0EIL+gGpMw5/CI9N3ejlmJC7wZic4R133Ca2JO
         G85QxutjOZIz5c3DbjWootzVUive84O6rC7AhbebepQyUDmj024K2EB1SeB9Az0F28uY
         lRoVT/fboxut6m+Pl3g259L7bPN4+gYi6Hkg1bOwv8HdaANwhW2d98byHiUK7V9bXkt4
         dLVgXZbhtJ0PEDNhEqdAIlUmF+T+eenLS+lcm2Jsxq7rtWamYklImuaMgo3AXhB/xXOx
         qAvBhQebJEinDCHU4lpYNwQkL7SDszVsIu/GOrj/93ja0x9J3s0cnypwG80shXcknOTp
         SAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=tJNevqO0XjK36FmENHY936OAEeTL8r5JxlA7yFe17JA=;
        b=PWfbOHPHElbw3dN4wvhwkAqdtZtzLfo5OXFZLSy0V0LRDTMv5Rw1CQgJXFzAXNXlZP
         //cLqr9VKax/Rn7EWNlEsJEE/p6RMv6/MInkKrjG5wOKBN5EBf34/ijEfAiY7RKBxQdu
         aNpPpH40rZTI3reORX0AmFXUSdkAgMbl2oNoFd28hQ+MHm1B2UzUYS2oGZgyYAEOzxK+
         mSyE7nP/9kuifoyu/YCJb6RrJ/4VK/WoAjl6Uv9LE2Tn+hoL/OX5Sa1Esd7KDHDyteOP
         ehOW6/YxZ4RL0eDttgX6vxxXQ2mBxdUN94aiPscCuKx5oFSslHUNkziC+LzduVf2qcFZ
         B4FQ==
X-Gm-Message-State: AOAM5309dDr0f5/139/5IgsA1vipPIioDYupa5MV6y1fEORmeRhdMswr
        Eb8das6f8UdZaZMZreV10TySFq4gN89DMlxa2lYE6HUl
X-Google-Smtp-Source: ABdhPJxZG8HHO0uZRVR7YVeat9PbepRLuVX4ChDf2rOWud4OkGuuXIZVdXg/1vpnfXQ2Jj9eTeGPZaAF+cE7Q8v6YXY=
X-Received: by 2002:aca:bc03:: with SMTP id m3mr2311934oif.35.1605104839296;
 Wed, 11 Nov 2020 06:27:19 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
In-Reply-To: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Wed, 11 Nov 2020 15:27:09 +0100
Message-ID: <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
Subject: Fwd: net: fec: rx descriptor ring out of order
To:     netdev@vger.kernel.org, Andy Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

We are using a imx6q platform.
The fec interface is used to receive a continuous stream of custom /
raw ethernet packets. The packet size is fixed ~132 bytes and they get
sent every 250=C2=B5s.

While testing I observed spontaneous packet delays from time to time.
After digging down deeper I think that the fec peripheral does not
update the rx descriptor status correctly.
I modified the queue_rx function which is called by the NAPI poll
function. "no packet N" is printed when the queue_rx function doesn't
process any descriptor.
Therefore the variable N counts continuous calls without ready
descriptors. When the current descriptor is ready&processed and moved
to the next entry, then N is cleared again.
Additionally an error is printed if the current descriptor is empty
but the next one is already ready. In case this error happens the
current descriptor and the next 11 ones are dumped.
"C"  ... current
"E"  ... empty

[   57.436478 <    0.020005>] no packet 1!
[   57.460850 <    0.024372>] no packet 1!
[   57.461107 <    0.000257>] ring error, current empty but next is not emp=
ty
[   57.461118 <    0.000011>] RX ahead
[   57.461135 <    0.000017>] 129 C E 0x8840 0x2c743a40  132
[   57.461146 <    0.000011>] 130     0x0840 0x2c744180  132
[   57.461158 <    0.000012>] 131   E 0x8840 0x2c7448c0  132
[   57.461170 <    0.000012>] 132   E 0x8840 0x2c745000  132
[   57.461181 <    0.000011>] 133   E 0x8840 0x2c745740  132
[   57.461192 <    0.000011>] 134   E 0x8840 0x2c745e80  132
[   57.461204 <    0.000012>] 135   E 0x8880 0x2c7465c0  114
[   57.461215 <    0.000011>] 136   E 0x8840 0x2c746d00  132
[   57.461227 <    0.000012>] 137   E 0x8840 0x2c747440  132
[   57.461239 <    0.000012>] 138   E 0x8840 0x2c748040  132
[   57.461250 <    0.000011>] 139   E 0x8840 0x2c748780  132
[   57.461262 <    0.000012>] 140   E 0x8840 0x2c748ec0  132
[   57.461477 <    0.000008>] no packet 2!
[   57.461506 <    0.000029>] ring error, current empty but next is not emp=
ty
[   57.461537 <    0.000031>] RX ahead
[   57.461550 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
[   57.461563 <    0.000013>] 130     0x0840 0x2c744180  132
[   57.461577 <    0.000014>] 131     0x0840 0x2c7448c0  132
[   57.461589 <    0.000012>] 132     0x0840 0x2c745000  132
[   57.461601 <    0.000012>] 133   E 0x8840 0x2c745740  132
[   57.461613 <    0.000012>] 134   E 0x8840 0x2c745e80  132
[   57.461624 <    0.000011>] 135   E 0x8880 0x2c7465c0  114
[   57.461635 <    0.000011>] 136   E 0x8840 0x2c746d00  132
[   57.461645 <    0.000010>] 137   E 0x8840 0x2c747440  132
[   57.461657 <    0.000012>] 138   E 0x8840 0x2c748040  132
[   57.461668 <    0.000011>] 139   E 0x8840 0x2c748780  132
[   57.461680 <    0.000012>] 140   E 0x8840 0x2c748ec0  132
[   57.461894 <    0.000009>] no packet 3!
[   57.461926 <    0.000032>] ring error, current empty but next is not emp=
ty
[   57.461935 <    0.000009>] RX ahead
[   57.461947 <    0.000012>] 129 C E 0x8840 0x2c743a40  132
[   57.461959 <    0.000012>] 130     0x0840 0x2c744180  132
[   57.461970 <    0.000011>] 131     0x0840 0x2c7448c0  132
[   57.461982 <    0.000012>] 132     0x0840 0x2c745000  132
[   57.461993 <    0.000011>] 133     0x0840 0x2c745740  132
[   57.462005 <    0.000012>] 134   E 0x8840 0x2c745e80  132
[   57.462017 <    0.000012>] 135   E 0x8880 0x2c7465c0  114
[   57.462028 <    0.000011>] 136   E 0x8840 0x2c746d00  132
[   57.462039 <    0.000011>] 137   E 0x8840 0x2c747440  132
[   57.462051 <    0.000012>] 138   E 0x8840 0x2c748040  132
[   57.462062 <    0.000011>] 139   E 0x8840 0x2c748780  132
[   57.462075 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
[   57.462289 <    0.000009>] no packet 4!
[   57.462316 <    0.000027>] ring error, current empty but next is not emp=
ty
[   57.462326 <    0.000010>] RX ahead
[   57.462339 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
[   57.462351 <    0.000012>] 130     0x0840 0x2c744180  132
[   57.462362 <    0.000011>] 131     0x0840 0x2c7448c0  132
[   57.462373 <    0.000011>] 132     0x0840 0x2c745000  132
[   57.462384 <    0.000011>] 133     0x0840 0x2c745740  132
[   57.462397 <    0.000013>] 134     0x0840 0x2c745e80  132
[   57.462408 <    0.000011>] 135     0x0840 0x2c7465c0  132
[   57.462421 <    0.000013>] 136   E 0x8840 0x2c746d00  132
[   57.462431 <    0.000010>] 137   E 0x8840 0x2c747440  132
[   57.462443 <    0.000012>] 138   E 0x8840 0x2c748040  132
[   57.462454 <    0.000011>] 139   E 0x8840 0x2c748780  132
[   57.462467 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
[   57.462697 <    0.000009>] no packet 5!
[   57.462730 <    0.000033>] ring error, current empty but next is not emp=
ty
[   57.462739 <    0.000009>] RX ahead
[   57.462752 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
[   57.462763 <    0.000011>] 130     0x0840 0x2c744180  132
[   57.462775 <    0.000012>] 131     0x0840 0x2c7448c0  132
[   57.462787 <    0.000012>] 132     0x0840 0x2c745000  132
[   57.462799 <    0.000012>] 133     0x0840 0x2c745740  132
[   57.462809 <    0.000010>] 134     0x0840 0x2c745e80  132
[   57.462820 <    0.000011>] 135     0x0840 0x2c7465c0  132
[   57.462830 <    0.000010>] 136     0x0840 0x2c746d00  132
[   57.462842 <    0.000012>] 137     0x0840 0x2c747440  132
[   57.462853 <    0.000011>] 138   E 0x8840 0x2c748040  132
[   57.462864 <    0.000011>] 139   E 0x8840 0x2c748780  132
[   57.462877 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
[   57.463093 <    0.000009>] no packet 6!
[   57.463120 <    0.000027>] RX ahead
[   57.463133 <    0.000013>] 129 C   0x0840 0x2c743a40  132
[   57.463144 <    0.000011>] 130     0x0840 0x2c744180  132
[   57.463155 <    0.000011>] 131     0x0840 0x2c7448c0  132
[   57.463166 <    0.000011>] 132     0x0840 0x2c745000  132
[   57.463179 <    0.000013>] 133     0x0840 0x2c745740  132
[   57.463190 <    0.000011>] 134     0x0840 0x2c745e80  132
[   57.463201 <    0.000011>] 135     0x0840 0x2c7465c0  132
[   57.463213 <    0.000012>] 136     0x0840 0x2c746d00  132
[   57.463224 <    0.000011>] 137     0x0840 0x2c747440  132
[   57.463235 <    0.000011>] 138     0x0840 0x2c748040  132
[   57.463245 <    0.000010>] 139   E 0x8840 0x2c748780  132
[   57.463256 <    0.000011>] 140   E 0x8840 0x2c748ec0  132
[   57.463695 <    0.000244>] rx 12

As you can see, the described error is catched and the ring is dumped.
9 descriptors got ready before the current descriptor is ready.
After that the current descriptor got ready and 12 packets were
processed at once.
I could also observe cases where the ring (512 entries) got full
before the current descriptor was cleared.
And also cases where the current and next descriptor were not ready.
[   57.462752 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
[   57.462763 <    0.000011>] 130    E 0x0840 0x2c744180  132
[   57.462775 <    0.000012>] 131     0x0840 0x2c7448c0  132

I am suspecting the errata:

ERR005783 ENET: ENET Status FIFO may overflow due to consecutive short fram=
es
Description:
When the MAC receives shorter frames (size 64 bytes) at a rate
exceeding the average line-rate
burst traffic of 400 Mbps the DMA is able to absorb, the receiver
might drop incoming frames
before a Pause frame is issued.
Projected Impact:
No malfunction will result aside from the frame drops.
Workarounds:
The application might want to implement some flow control to ensure
the line-rate burst traffic is
below 400 Mbps if it only uses consecutive small frames with minimal
(96 bit times) or short
Inter-frame gap (IFG) time following large frames at such a high rate.
The limit does not exist for
frames of size larger than 800 bytes.
Proposed Solution:
No fix scheduled
Linux BSP Status:
Workaround possible but not implemented in the BSP, impacting
functionality as described above.

Is the "ENET Status FIFO" some internal hardware FIFO or is it the
descriptor ring.
What would be the workaround when a "Workaround is possible"?

I could only think of skipping/dropping the descriptor when the
current is still busy but the next one is ready.
But it is not easily possible because the "stuck" descriptor gets
ready after a huge delay.

Is this issue known already? Any suggestions?


Thanks in advance
