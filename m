Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0B58E371
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiHIW4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiHIW4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:56:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D889251A11
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 15:56:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k26so24750247ejx.5
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 15:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=6C2gIv7i6C6wTGnwkYqV5ncS0XvLsgKNdJye2w86FPY=;
        b=Fy7VrEPwkPUqksuiQuuzcSm9CHzs9QHtl6SE9IJFveraXr9kr2Dizt8HcdAjKSTEPe
         8pusN2GrOOUcY6QQgdR5rUstYcM8PsEWe57XAXvhQ4+aDJU2srMs8apWjGunTrwr82Bj
         Aj1s/2fnaG+70cujlj/aU7JGCroKDYK28X2oJ9q6DarcsVfC6nr3VNdjIrehEYNWCEPo
         OnmFDnmcus+X1hYIPhEgl4Rrs/ZwfYoKj0GiD6TQSmnZ5le3Q4vuQgbwCDFpj3sZHttk
         pZh7pzKu9d/2lkp0/XlANhIij+8tiEXdqEeFcHWbPxSYPlYNobWoXIw26ofE2piqfcbw
         iTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=6C2gIv7i6C6wTGnwkYqV5ncS0XvLsgKNdJye2w86FPY=;
        b=4AYxVES77P9KCGLONjnURUNkHvFe+XfGqYjd+N3cpDUQaCYS1dQXaVp0e8yh68jqED
         QGF1rp/EvPHgYqVeGjaZ7gvB+wky4mjZ5DVyLgrheJlwePVxYvVjEMamqzfn72cZOAvF
         XCkQNphbimvQq02DmOGEyrDHwzRVqkHOWy7NjmILzOUkTdf9T/8dENFlmOcGGdoxNM0P
         NKxabx75yMeaL0vAEIBKCFuhy6aV01cQDQ8UQm6mZUn8o3Ie9Uwn6/7m2Q0ZS5c9jB4o
         ExsVQbt3iB9H+s/Cx2aL+FjQZ+d+aGazSj+DXviP8NhXRA8xkXelGCEln92Vl3TN8S+e
         rGjA==
X-Gm-Message-State: ACgBeo3laRSHu9yATA99+xo5uJtiA+riJbD+aOkLqG7Rb5vXjZqU6/Pf
        3dmFp1v/4oxkwcKxUl/sQy8rHxgf5B8=
X-Google-Smtp-Source: AA6agR793I0Yy4bRmdEV6Ru/w1rFACqjUihE3JH+LevrxowJbqYEHwLrRqwiC4/W3XlMBKkIH7iNkg==
X-Received: by 2002:a17:906:93fa:b0:731:a80:2444 with SMTP id yl26-20020a17090693fa00b007310a802444mr14557770ejb.121.1660085790396;
        Tue, 09 Aug 2022 15:56:30 -0700 (PDT)
Received: from [192.168.2.114] (p5b3dd6ec.dip0.t-ipconnect.de. [91.61.214.236])
        by smtp.gmail.com with ESMTPSA id en19-20020a056402529300b0043a87e6196esm6589078edb.6.2022.08.09.15.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 15:56:29 -0700 (PDT)
Message-ID: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
Date:   Wed, 10 Aug 2022 00:55:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com
From:   Philipp Rossak <embed3d@gmail.com>
Subject: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Cc:     philipp.rossak@formulastudent.de
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I currently have a project with a Toradex Colibri IMX8X SOM board whith 
an onboard Micrel KSZ8041NL Ethernet PHY.

The hardware is described in the devictree properly so I expected that 
the onboard Ethernet with the phy is working.

Currently I'm not able to get the link up.

I already compared it to the BSP kernel, but I didn't found anything 
helpful. The BSP kernel is working.

Do you know if there is something in the kernel missing and got it running?

Thanks,
Philipp
