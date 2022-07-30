Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1265858C1
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 07:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiG3FO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 01:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiG3FO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 01:14:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824CD78222
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 22:14:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so7060475pjl.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 22:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=UIzKl54psEvaSWq6oiqmUcJnLM0vGwR7VbRywy+/SVrynhPOE2oT9lOLFrjKZO/G/v
         4oe+LJdnXUiapnzeJcDh+uDo0fwvlgWhynRBdq426n4PUUBcuXKBsOFhDDUyz+UaGaHa
         BJwFIQF1RHDpS2PvT5S0wb5+uzrueXzsHoZpWcm9bYqXCOm+Lu4s1R3veHODy0VX9tR/
         vo8SiqbWMKETxmdOi34NGR5+rqVgRXypICZ1fGiXajUdmAZ4A0KL7YfLPhjLmg784qxC
         WkGK1abXrtFpLQ1dVZvu4tbo1wKfw5+LuJhZCle4AcoJctKiQFGU6608AQuj3iYM7d4p
         hINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=tkbO/ZVANtzf9Q/151x6gICZDDLp4xMAqWnPVLqUMyv6BAfMm5PR/mAI79MlUxjS3n
         SbzW9vNlDOgA/gsVcGy4QQzjmtTGnK8ciehHK+PZ3eul1B9hrG4LWGw31HnbsGheAjdn
         9qOdS1zNXubYNG1nvxRGcqlIG/Sh9DqE43tjqFTAlIIwzxtfPXiSqLX31CW8m7r8AaPx
         sFVv6WHdROvGVDXXgcbqq2WkzLAXgBYQhhaJCwD4W0RuD49MhF6318XEneAJneuT/i3l
         8gSQEucymucCfV+QBdjLjHd3RaxKfwmluNKA4osTqGgzVHD234kiHiURBbve6FKiHHdI
         zo3Q==
X-Gm-Message-State: ACgBeo0KylRsA9QfsRe3xdh/k3VQ8jc4ZducoUdqpKFy+qOch/SR0HUD
        foqo/coepETjROZgQnI6Fkdy0cDihkl7b3g5M2w=
X-Google-Smtp-Source: AA6agR7PuoqWxtyhr8lXNd3iGujRrN2MjRvlPNJzlPfczs0NFmvgoYyq7miaw8a7MhRsE8pitXBfbGV1FROTjWLbsg8=
X-Received: by 2002:a17:90a:4802:b0:1f2:9380:7054 with SMTP id
 a2-20020a17090a480200b001f293807054mr8269155pjh.98.1659158064676; Fri, 29 Jul
 2022 22:14:24 -0700 (PDT)
MIME-Version: 1.0
Sender: valerybayala0@gmail.com
Received: by 2002:a05:7300:764c:b0:6b:1959:8d4b with HTTP; Fri, 29 Jul 2022
 22:14:24 -0700 (PDT)
From:   Mimi Hassan <mimihassan971@gmail.com>
Date:   Sat, 30 Jul 2022 06:14:24 +0100
X-Google-Sender-Auth: cHNtTNxQb1W85OL-IX-fSad3AXI
Message-ID: <CABJwvBqBoG5dV7D7oPFLLLoYeaZGJ8MRR7stoFFdTAJxJbM9OA@mail.gmail.com>
Subject: I WILL TELL YOU HOW TO GO ABOUT IT.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i am Mrs Mimi Hassan Abdul Muhammad and i was diagnosed with cancer
about 2 years
ago,before i go for a surgery  i  have to do this by helping the
Less-privileged,so If you are interested to use the sum of
US17.3Million)to help them kindly get back to me for more information.
Warm Regards,
Mrs Mimi Hassan Abdul Muhammad
