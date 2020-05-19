Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0CF1D9883
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgESNsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgESNsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:48:46 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E54C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:48:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id m12so3164589wmc.0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CZOZ6zJl7K+CX7mG44VkFRrQ+i68m5YSb/XRoNfw+DM=;
        b=Mrs7az2ujMCZM7u4p1HNRiYL9Q67GNgOk7gmaD/jRcyUMJTE+eNG9fXo2ZH90tu+Re
         9LEmufULds6k+XlWfOsfPo7CdXaS0gDPxd3Ll2iLUJfnlRc5xDl1fJLaUA7LxHsJFHq7
         DDXNSmE+m7qImgDHuqG4aryguhtcvL6RAp+LrOLPQ6Rya4942CvN133JvMygOi1zeEOv
         6nNHm8v+7HH3HfyqmK1wCzDSGrEBVOMGBrFzOea8aaA5AMwLsjcE1+ib8ZSbuyMTOU31
         fqT8rKP2IvWp/xO1DNhtAeZDv961G+w5EP2YijeFi9DqJqf58XSrR/gvl8Bm2X15/Jdt
         OuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=CZOZ6zJl7K+CX7mG44VkFRrQ+i68m5YSb/XRoNfw+DM=;
        b=I039pPxbavvIuGcmnEQV+ubI+Vn3x3d+un5u8TPZS8cRVVZd++8Im9zUF51wQ9eAAk
         /n1+FQb821nVBLgVnPHLXZeUOBqeX0FqwcQkq5xlgxaHfTA2UgYtU6wvhX6/AS+E2z4w
         kf4mQw5oHL/2kIemw5mFv6Zv5R6d2grfOxcumFr+Grqn48kQWkkTCcWOMKWljz4kqzsB
         N5+Vv8O3OnxbhCdNeNW9KXUFkd/1SE7Jgv67tOBKfVOoUwctV173to4svsLJoW2RQdb3
         4s9gO9hhBv+A5B+aGTjonVLpiA6M6UlyGuRe7EniZZ87BwO9ZBn/kZqGMWJa227fwooZ
         VHjw==
X-Gm-Message-State: AOAM533JapVP3nwXr+iK1fQG8nugdYe0dGcON5mrsA+mcj2NhkvZA2Pv
        Bq1xNNA7i+OdHZPstwhVCq3DEL4Pur28KLk61IU=
X-Google-Smtp-Source: ABdhPJxCrURXsT+XlaC6Rh8oJjSw/GHwKnetzopcPC99xSKyiZo7nTCuqTRwF5Xs9lA10G+E43FoUyUx/fnG64DcB8E=
X-Received: by 2002:a1c:2702:: with SMTP id n2mr5730850wmn.107.1589896124146;
 Tue, 19 May 2020 06:48:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:60d0:0:0:0:0:0 with HTTP; Tue, 19 May 2020 06:48:43
 -0700 (PDT)
Reply-To: azizdake0@gmail.com
From:   Aziz Dake <palwil75@gmail.com>
Date:   Tue, 19 May 2020 06:48:43 -0700
Message-ID: <CAJncpkQ8s002qf3diXq8vER5CR4tsJZj0OC8KCVw6NJZ9K8Ytg@mail.gmail.com>
Subject: From Honourable Barrister Aziz Dake.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attn: Sir/Madam

I am Honourable Barrister Aziz the personal resident Attorney here in
Burkina Faso to Late Mr. Muammar Muhammad Abu Minyar al-Gaddafi of
Libya c. 1942 =E2=80=93 20 October 2011.

My client Late Mr. Muammar Muhammad Abu Minyar al-Gaddafi c. 1942 =E2=80=93=
 20
October 2011, was having a deposit sum of {thirty million four Hundred
thousand united state dollars} only ($30.4M USD) with a security
finance firm affiliated with African development bank here in Burkina
Faso.

With the above explanation=E2=80=99s I want to move this money from Burkina
Faso to your country, affidavit on your name, but note that this is a
deal between me and you and should not be related to anybody until the
deal is over for security reasons, please if interested reply as soon
as possible.

Thanks,
Honourable Barrister Aziz Dake.
