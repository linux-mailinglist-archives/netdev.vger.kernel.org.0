Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C714169C5
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243848AbhIXCE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243792AbhIXCE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:04:27 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB81C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 19:02:55 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 24so12533858oix.0
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 19:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dgpwPCQznEmVXGZRT9a+ot3RVGNTTHbl31G3nps7wKQ=;
        b=hKz8RC3SOhSmX3zVPvb/WziL2fRzz11bqqCwdwIKBGBWnseUgqJten4tt5aDdGx6D2
         JWC124Fx36Tofk0xpu+MmvaDd3nhv1ZdxcgMhpkIbQg10uU/58m3pWCg9slwm761Xvqk
         W5cUhIk4PWiW1M8tOoFp9kTAWOImqngSysK0Det7DItxyk510Wf69dfz/pcP3RESSb/y
         TYUT6Vr/B965YoepN560fzgxVfCWDxsOcVCHuF/JJegJheXI6CaxQBdhZZYX9SoqAj+m
         ertbCyC3YWhCjgKOxxCMoTFaunR4D1hFXugAvmJvBXZGG/iZ5oK5OIpRur00V3F/sMOB
         KTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=dgpwPCQznEmVXGZRT9a+ot3RVGNTTHbl31G3nps7wKQ=;
        b=DvizuNjw5SoHG1J+UpcB0gBHNCpZr/s1dXfGhfZvv6lp55d+yh8RHzunsT0Od3Prmo
         z5cD+aqA/huW682GyX2AFi/DEvk57h/Z1KsohNRK6SEM9MJHQqYmWizCLoEFj0xyFifi
         aoxRJrjTsQY6gLJiqvXcHvjCuxSfhYU2kHohhprvLFSrBTT3e9Imgps+q/7bhmzQ8/3z
         VPIoRQeCjIavO6EgkOUDwYhi3skFc0+nRY6ks5LhYXA71E/sV1eFm16n8T93V2/yyUUJ
         MIDhhYb+iSf5ZzP8sGyhplElEe6hSSebf2EkLbnoZSturOWXTdQV+sGSxjWDVpcrkuKb
         9heA==
X-Gm-Message-State: AOAM532+gAPW4ZuibrFwBxomoiY1Dz10C9sJOf7u0ZJWuN1PryIzItNQ
        CVpleSx+V5i1kddl3e9q8f8h8MHw4x3/ddHi9SynaKGUiCnVopnx
X-Google-Smtp-Source: ABdhPJxhRvhZAiaGrHqCpHRLUm9YRKoxLqvPmBrUtkoyv/gYXlFw1veaYr9l1MVHMjyQ3M+zAjoE4zrWSUp+hk467GE=
X-Received: by 2002:aca:604:: with SMTP id 4mr7830971oig.8.1632448974010; Thu,
 23 Sep 2021 19:02:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:d587:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 19:02:52
 -0700 (PDT)
Reply-To: michaelrachid7@gmail.com
From:   Michael Rachid <hamidfaith031@gmail.com>
Date:   Fri, 24 Sep 2021 03:02:52 +0100
Message-ID: <CAFepVPqmjP+vRtQnCs0Kg+AFw0D-gowEK=du206+gmrZ0iDY5Q@mail.gmail.com>
Subject: =?UTF-8?B?7KCc7JWIIGplYW4vUHJvcG9zYWw=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7Lmc6rWs7JeQ6rKMLA0KDQrrgpjripQg64u57Iug6rO8IO2VqOq7mCDsspjrpqztlZjqs6Ag7Iu2
7J2AIOyCrOyXhSDsoJzslYjsl5Ag64yA7ZW0IOyVjOumrOq4sCDsnITtlbQg6riA7J2EIOyUgeuL
iOuLpC4NCjXsspzrp4wg64us65+s6rCAIO2IrOyeheuQqeuLiOuLpC4g66qo65OgIOqyg+ydtCDt
lanrspXsoIHsnbTqs6Ag7JyE7ZeY7ZWY7KeAIOyViuycvOuLiCDslYjsi6ztlZjsi63si5zsmKQu
DQrqtIDsi6zsnYQg7ZGc7Iuc7ZW0IOyjvOyLreyLnOyYpC4NCg0K66eI7J207YG0IOudvOyLnOuT
nC4NCg0KY2hpbmd1ZWdlLA0KDQpuYW5ldW4gZGFuZ3Npbmd3YSBoYW1ra2UgY2hlb2xpaGFnbyBz
aXAtZXVuIHNhLWVvYiBqZWFuLWUgZGFlaGFlDQphbGxpZ2kgd2loYWUgZ2V1bC1ldWwgc3NldWJu
aWRhLg0KNWNoZW9ubWFuIGRhbGxlb2dhIHR1LWliZG9lYm5pZGEuIG1vZGV1biBnZW9zLWkgaGFi
YmVvYmplb2ctaWdvDQp3aWhlb21oYWppIGFuaC1ldW5pIGFuc2ltaGFzaWJzaW8uDQpnd2Fuc2lt
LWV1bCBweW9zaWhhZSBqdXNpYnNpby4NCg0KbWFpa2V1bCBsYXNpZGV1Lg0KDQoNCkRlYXIgZnJp
ZW5kLA0KDQpJIHdyaXRlIHRvIGluZm9ybSB5b3UgYWJvdXQgYSBidXNpbmVzcyBwcm9wb3NhbCBJ
IGhhdmUgd2hpY2ggSSB3b3VsZA0KbGlrZSB0byBoYW5kbGUgd2l0aCB5b3UuDQpGaWZ0eSBtaWxs
aW9uIGRvbGxhcnMgaXMgaW52b2x2ZWQuIEJlIHJlc3QgYXNzdXJlZCB0aGF0IGV2ZXJ5dGhpbmcg
aXMNCmxlZ2FsIGFuZCByaXNrIGZyZWUuDQpLaW5kbHkgaW5kaWNhdGUgeW91ciBpbnRlcmVzdC4N
Cg0KTWljaGFlbCBSYWNoaWQuDQo=
