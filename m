Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9028D036
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgJMO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388627AbgJMO3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 10:29:32 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA25DC0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:29:32 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u17so22694304oie.3
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Vy3vUO83x5VAzY+plRwMUiovRacxSJu8+7jMQrZRSPA=;
        b=EaIo+9C+6TNSuSOnrOQo/wYVdMyPoEqhoHukNorwZ/gbApRXU0tXbKu86lxbNoGW56
         uM2xMjUCMV377OsQAwZ1bAGEwDddY5rKsTwAVLJKmkTSHig8/UcfnTQSNjhKQuzRsXHx
         /dYOLYh8a3Uui69Qc3ewruT2X/4gki3PF2C7UKfCX1tFWw1CoNnTNcMCoeq2lCwjWdmP
         CUBgyG8NseReIxY9ujlp4xXio8M4OFbv3umrsOeJuXid+EF7Qec3RkvFfEOG2K+vkJVg
         97DtRtlPR10PZqBLD6aOJ30ZsGjKaGFmM8eZN8jd1vPi7YVaIk2On2b4syGC+OCVnC7z
         75Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Vy3vUO83x5VAzY+plRwMUiovRacxSJu8+7jMQrZRSPA=;
        b=rVTvIWKCZ3n19c6Crwv6BbWBK0DBSJRAjlrqUGTbyJ+8S9Tk0miS211SRIpS0RgNsK
         lV5JfqQs+beqwswxCFgptNM3pNLlqo2f8uY5DZCmKOROzykY4CnNqRWQO6ho1waAq656
         4uSowVQW8wgxLoO0DpsvX8RrJp9ykQtyNguF0ASlTebj8uUBSFYCFJhViNDAA/YhIe9q
         XxwYNjlWMByFZ/m2cYcO3MLobjJnNRCrLG4sI8EOJ03qmw3CBFRu1awG3teSie2YRPrW
         uKGaC/TVjsRQchqMs2MVFl6ggv9tIV0iJ2bwPPv3Qzd1wzGdR4q4RaTc6qbEN8zfm5f4
         x4kA==
X-Gm-Message-State: AOAM532uJTe7gNIWDK5RD+bAmVv3OGdE9c3BhTpp26NdvuAq8K3yjJaG
        PYctw9kaQnZMURHYnkvE7rWtyevRTO8ss2wzrNgfdn6zf98=
X-Google-Smtp-Source: ABdhPJyt/gSs9lW9+zm+TfAAYX4+ZTE+/42CfT7X1eQ+sxuib/qSOxcIcxR5oNqh/aMJcQGqp6YG8BGozD79VApN6UQ=
X-Received: by 2002:aca:c341:: with SMTP id t62mr115118oif.73.1602599372005;
 Tue, 13 Oct 2020 07:29:32 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?15zXmdeo158g15DXldeT15nXlg==?= <liranodiz@gmail.com>
Date:   Tue, 13 Oct 2020 17:29:21 +0300
Message-ID: <CAFZsvkmCzSzK2SDivNvjhaq6fbXro-++BsVKCneDd=8hkdrsow@mail.gmail.com>
Subject: =?UTF-8?Q?Ip_Rule_For_GRE_Tunnel=E2=80=8F?=
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Is it possible to set IP rule for GRE tunnel? in the IP rule man
there is missing information about the "tun_id" selector parameter,
what is the meaning of this parameter?

How can i set IP rule for the following GRE tunnel?



[root@localhost /]# ip tunnel show
gre0: gre/ip remote any local any ttl inherit nopmtudisc
tunl0: any/ip remote any local any ttl inherit nopmtudisc
sit0: ipv6/ip remote any local any ttl 64 nopmtudisc
greT1: gre/ip remote 70.70.70.2 local 70.70.70.1 ttl inherit key 1
ip_vti0: ip/ip remote any local any ttl inherit nopmtudisc key 0



BR, Liran Odiz
