Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F3A3B0A04
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFVQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhFVQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:13:46 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA60C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:11:29 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b5so6949523ilc.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=F91OyL/+xY34jJfXt7AssfIqEwcD+/1Ib731Z4+UgEM=;
        b=iee1naa6gFYaZ+vZCbVQH1j2eXLMRfSWqCy/YmkIrMuM6A153DhWpaVixGIFphUYZG
         Z+T1MRIrKcHXxLP5gI66jiYAqDmVYLYnGIMQvjBaNexTaSD6LMseU2ESLGL3Y3EnIP9d
         9Pn5t4ouZKyzYyvSPq6t8kotEE0GL4wpEESmtAAxiUbovD6m3pW3ZaqI5C4OxIPx6l5W
         HrAATH6+DWAUySbLXheP1MN/Tj30hfakzQpKWY8Pwy+p/nwyhsrBSwVDoIplyXjlabmy
         mGCoX0r6iXqv9jm5zarFrdGxzt5gQENTUonJcQfPdJUJwPpx7xst8oZU96XZJ6Gnenrj
         BqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=F91OyL/+xY34jJfXt7AssfIqEwcD+/1Ib731Z4+UgEM=;
        b=cWeb26IH6KMvW3GoM5uc5FkGYPd0BmxL9Ypb3Gshq+mVaqwrmjeM/11WXH130UHls/
         knzd+F2vOLUHfQUNr1rZlibXO0rnfKXQEzwbszUqGRQ4+xZ4+O8IfUKEu4JsOBB2lqCZ
         6SxFGLWr1IgD0dQRtlmlVOzhs4oYSOQDLaeiat657ZQOlAzOOcMGPc/74sBUZ3yWtx+A
         0cV6RdHMNATDmWJEbFzQsc3gsxE1yFxB6Bkmmgjnu4+Ixamcm61Q7i67/NPwtbBFpwHs
         EKr3hMGpA9XH0PFzGl8NWhroFIEW/gjnWznZQW0kSzQHsts4mgvH6taJbDslQ53tf4do
         3m2A==
X-Gm-Message-State: AOAM533ttXOduGU1UM02tPYF91DXADAQXYg/VaHV42P7wWBZYtpl9d/t
        S9rtt4T25/pWN7U0H32TzYWthJJ0k8xpLMnjHD7zbCzZM3U=
X-Google-Smtp-Source: ABdhPJwyeZ1aPMQ0ko/ppNMYSZu5TViRQWRHfWZOWJYy6/t2dFsUE9eygPldAO3NcJx72g+y6Dvj1OiAUx5X0Vhl2PA=
X-Received: by 2002:a05:6e02:10c3:: with SMTP id s3mr3123670ilj.37.1624378288877;
 Tue, 22 Jun 2021 09:11:28 -0700 (PDT)
MIME-Version: 1.0
From:   Gaurav K <gauravkpfs@gmail.com>
Date:   Tue, 22 Jun 2021 21:41:18 +0530
Message-ID: <CAOfPAPJU0TcV12TsPy-=FoZPfLth5J_azvNkz1GpyjueEma8QA@mail.gmail.com>
Subject: vrf xfrm
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

If there is a minimum kernel version that should be used for ipsec
with vrf, can you please help me with that?

Thanks
Gaurav
