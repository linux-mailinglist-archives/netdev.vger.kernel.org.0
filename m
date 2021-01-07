Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BEC2ED5CA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbhAGRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbhAGRiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:38:46 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BECCC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:38:06 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id l11so16581500lfg.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BTm7Ek9eFIVDVQq2gb81U3Fi+k4EHTwQy9UjnVwPdgY=;
        b=E4ANiVZYW553c2rH+kqHfyVhsNdyVsrqZIHDJ+EG1lvbq8VkKTFkszWw3ZidcNCdkx
         sRGurudZV7P7iodl7Pxz8OVygEM9dCO90lctxQVBCbMKpmTt/1DZUVXFiUraY1Q3CmFl
         W0HEQH9x90IymBOG+302iqI74+chs2+fB/fS7YeeFWJWs2Zd+aoCXOMmWx8jbjwOA2V/
         cgT2InIUgdO66IdnsyK51ct7mRvQrwHL0I1lI2581X9VEFcL4DfjYHvRMWMbr6yUa7ng
         /2hhcPCsT0l+Y/QaQQE+xIPB8BABeVRRjbKzdbLcWrGC2puJiHRJRbvPVaHyU7BUC+wp
         ObkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=BTm7Ek9eFIVDVQq2gb81U3Fi+k4EHTwQy9UjnVwPdgY=;
        b=ejtpwxWJ8L4qYp4RIf/kvp1LlU4af6nCE0xDWyHVqt2lDpHQo1ea8guoP9a8MldQHW
         2h9jItCq9c4pKNPG7Qa5hD1fPmTxBbBpqXyxzZqBH1mA3mLRS59YWEXQ+Wl9IGBzBKb2
         IkgAqBZlp4yieovNQf06W6Tazcj7zELafiGNhDArwd/jo0R8BHNgD+XRxUNlMFCZ+3gV
         363qOLalllqaQyQYwXiV267LaaFSCvyJ+dPyvdSzlKvS3ujAwd81+GelTTm5MefR3Y5r
         A8hz5xbLfkJkruGja+Q2GP+FWmUqsHBubeu0OpRhMIAFu+NyCpBx1TyQiI6X2fdA1NQo
         ry7w==
X-Gm-Message-State: AOAM531B/BldBxfpYPROMAb3TtelncFUqZI1ggM0IJE50UeeVXr5/xdK
        t6nI/045eo3xDAoGy+qBG6Zs5Xp31M6zURdnjEM=
X-Google-Smtp-Source: ABdhPJwypHJcYry89zPHM4kQrwuw00qpkdHn/DVB5Mp60s5ydzefht212qaRF1X6+gl0LVRIF3zt+H0V0cAEsu7d8OA=
X-Received: by 2002:a19:8a43:: with SMTP id m64mr4240274lfd.472.1610041085027;
 Thu, 07 Jan 2021 09:38:05 -0800 (PST)
MIME-Version: 1.0
Sender: espoirdavila@gmail.com
Received: by 2002:a05:6520:2029:b029:b1:b11f:5c97 with HTTP; Thu, 7 Jan 2021
 09:38:04 -0800 (PST)
From:   donna <sg.donna3881@gmail.com>
Date:   Thu, 7 Jan 2021 06:38:04 -1100
X-Google-Sender-Auth: gUEZHdjfRRxUN3yNbfARhLnO8l0
Message-ID: <CA+ZnPMPebXN3LezTxApJpgCJkTkd_yKfZjw+6i3gdf-jts81yw@mail.gmail.com>
Subject: Donna
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQpIaSAsDQpteSBwbGVhc3VyZSB0byBtZWV0IHlvdS4gSSdtIFNnLiBEb25uYSBmcm9tIHRo
ZSBVbml0ZWQgU3RhdGVzLA0KIGhvcGUgdG8gZGlzY3VzcyBzb21ldGhpbmcgaW1wb3J0YW50IHdp
dGggeW91LiBUaGFua3MNCg0K0J/RgNGL0LLRltGC0LDQvdC90LUsDQrQnNC90LUg0L/RgNGL0LXQ
vNC90LAg0L/QsNC30L3QsNGR0LzRltGG0YbQsC4g0K8gU2cuINCU0L7QvdC90LAg0Lcg0JfQqNCQ
LA0KICDRgdC/0LDQtNC30Y/RjtGB0Y8g0LDQsdC80LXRgNC60LDQstCw0YbRjCDQtyDQstCw0LzR
liDQvdC10YjRgtCwINCy0LDQttC90LDQtS4g0JTQt9GP0LrRg9C5DQo=
