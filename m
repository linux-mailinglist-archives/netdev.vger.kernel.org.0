Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED040C3FB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhIOKwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhIOKwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:52:47 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F027C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:51:27 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i4so5207761lfv.4
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jugmU6zxXuRvTadmLkTuUJDMJv4tKYHJ4uha6ABX0aY=;
        b=dEsWvWxaBr3S+FM9qKRbq94daYbfbKC88JB7y2JCZXz6GNTQkpb+KAjC4CzDMFbCr5
         C13kymM6ubiO2j26y5AaHC37re6u7kgBYCHTn71vYjeB/HhMjRR0nfaoRr2VAxz8MOjx
         mvxoHo6g6v5NmuwKOxhzTH3i5deumZ367f7oPyLzTQsV7+/+Q+YoMOykYix2Pe+ZC9PO
         vbAT16opv8PBJDDmAi0t/3cDIoddMu602a7dAIIVCqV4/BYLxf40Z47/PwZz38dPW9Y1
         5/IBKsRD7QERDNFj6AcL28sPt+Fh5STdNrlvzyGWDThICTl2UMZLm7eLHqt5S9nhIiHU
         I2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=jugmU6zxXuRvTadmLkTuUJDMJv4tKYHJ4uha6ABX0aY=;
        b=nKePeSjqsh070rP1aglXJDwcajPpYj8SSdVlEDTHXMBUXPnSYg0oT92udNv68qbetO
         sdPZKPbZWlNtONYAThZ4m7N5MDKYdQR81DvahSD8JbFYAexW4FqwfVPqyWkAKr0TRiN0
         fTWWCnKwsoxCmkRJ2LcCg2+aRcL6ygU92zqbfm/tO3qXze5IMh9Bw6msM4t4ximX6Y0U
         JJZh4FFaQX3h6Q3ZwIbKMk+5CbOAZMT1IqCmIMRjRAWsI3hL0Jmf+qE5fL+iFzHRssuZ
         Q3DGdwwWrjxe8BtVdJDFC7sGRtwRaX6KFu+tuAUoVh38+SgvFj2D64eiXjWzaN0RKb5i
         TtFg==
X-Gm-Message-State: AOAM531NhFqYzO3sWilfAMPFEa258PkZPqSGh8auk/NPNsvoEJEA57nh
        S8h+zCuq3mhQW66tCMggkpaGAVslSTv2uBT5xwc=
X-Google-Smtp-Source: ABdhPJyrJQkCfvcBCcZ8DLU2orUDViO/iZDsIbJMPFUo87K6hxpEZSzExZkSy/ineIwQkS2YaFkYvscLXShjtV4SDSA=
X-Received: by 2002:a05:6512:10ca:: with SMTP id k10mr1868453lfg.438.1631703084837;
 Wed, 15 Sep 2021 03:51:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:1313:0:0:0:0 with HTTP; Wed, 15 Sep 2021 03:51:24
 -0700 (PDT)
Reply-To: liampayen50@gmail.com
From:   liam payen <madamegueye948@gmail.com>
Date:   Wed, 15 Sep 2021 03:51:24 -0700
Message-ID: <CA+EfE3Gvbi=sKLwVksYkDEyfTF=a+Q244s0275MbnvsiwDRv_g@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5oiR5piv5Yip5Lqa5aeGwrfkvanmgankuK3lo6vlpKvkurrjgIINCg0K5Zyo576O5Zu96ZmG5Yab
55qE5Yab5LqL6YOo6Zeo44CC576O5Zu977yM5LiA5ZCN5Lit5aOr77yMMzIg5bKB77yM5oiR5Y2V
6Lqr77yM5p2l6Ieq576O5Zu955Sw57qz6KW/5bee5YWL5Yip5aSr5YWw77yM55uu5YmN6am75omO
5Zyo5Yip5q+U5Lqa54+t5Yqg6KW/77yM5LiO5oGQ5oCW5Li75LmJ5L2c5oiY44CC5oiR55qE5Y2V
5L2N5piv56ysNOaKpOeQhumYn+esrDc4MuaXheaUr+aPtOiQpeOAgg0KDQrmiJHmmK/kuIDkuKrl
hYXmu6HniLHlv4PjgIHor5rlrp7lkozmt7Hmg4XnmoTkurrvvIzlhbfmnInoia/lpb3nmoTlub3p
u5jmhJ/vvIzmiJHllpzmrKLnu5Por4bmlrDmnIvlj4vlubbkuobop6Pku5bku6znmoTnlJ/mtLvm
lrnlvI/vvIzmiJHllpzmrKLnnIvliLDlpKfmtbfnmoTms6LmtarlkozlsbHohInnmoTnvo7kuL3k
u6Xlj4rlpKfoh6rnhLbmiYDmi6XmnInnmoTkuIDliIfmj5DkvpvjgILlvojpq5jlhbTog73mm7Tl
pJrlnLDkuobop6PmgqjvvIzmiJHorqTkuLrmiJHku6zlj6/ku6Xlu7rnq4voia/lpb3nmoTllYbk
uJrlj4vosIrjgIINCg0K5oiR5LiA55u05b6I5LiN5byA5b+D77yM5Zug5Li66L+Z5Lqb5bm05p2l
55Sf5rS75a+55oiR5LiN5YWs5bmz77yb5oiR5aSx5Y675LqG54i25q+N77yM6YKj5bm05oiRIDIx
DQrlsoHjgILmiJHniLbkurLnmoTlkI3lrZfmmK/luJXnibnph4zmlq/kvanmganvvIzmiJHnmoTm
r43kurLmmK/njpvkuL3kvanmganjgILmsqHmnInkurrluK7liqnmiJHvvIzkvYblvojpq5jlhbTm
iJHnu4jkuo7lnKjnvo7lhpvkuK3mib7liLDkuoboh6rlt7HjgIINCg0K5oiR57uT5ama55Sf5LqG
5a2p5a2Q77yM5L2G5LuW5q275LqG77yM5LiN5LmF5oiR5LiI5aSr5byA5aeL5qy66aqX5oiR77yM
5omA5Lul5oiR5LiN5b6X5LiN5pS+5byD5ama5ae744CCDQoNCuaIkeS5n+W+iOW5uOi/kO+8jOWc
qOaIkeeahOWbveWutue+juWbveWSjOWIqeavlOS6muePreWKoOilv+i/memHjOaLpeacieaIkeeU
n+a0u+S4reaJgOmcgOeahOS4gOWIh++8jOS9huayoeacieS6uuS4uuaIkeaPkOS+m+W7uuiuruOA
guaIkemcgOimgeS4gOS4quivmuWunueahOS6uuadpeS/oeS7u++8jOS7luS5n+S8muWwseWmguS9
leaKlei1hOaIkeeahOmSseaPkOS+m+W7uuiuruOAguWboOS4uuaIkeaYr+aIkeeItuavjeWcqOS7
luS7rOWOu+S4luWJjeeUn+S4i+eahOWUr+S4gOS4gOS4quWls+WtqeOAgg0KDQrmiJHkuI3orqTo
r4bkvaDmnKzkurrvvIzkvYbmiJHorqTkuLrmnInkuIDkuKrlgLzlvpfkv6HotZbnmoTlpb3kurrv
vIzku5blj6/ku6Xlu7rnq4vnnJ/mraPnmoTkv6Hku7vlkozoia/lpb3nmoTllYbkuJrlj4vosIrv
vIzlpoLmnpzkvaDnnJ/nmoTmnInkuIDkuKror5rlrp7nmoTlkI3lrZfvvIzmiJHkuZ/mnInkuIDk
upvkuJzopb/opoHlkozkvaDliIbkuqvnm7jkv6HjgILlnKjkvaDouqvkuIrvvIzlm6DkuLrmiJHp
nIDopoHkvaDnmoTluK7liqnjgILmiJHmi6XmnInmiJHlnKjliKnmr5Tkuprnj63liqDopb/ov5np
h4zotZrliLDnmoTmgLvpop3vvIgyNTANCuS4h+e+juWFg++8ieOAguaIkeS8muWcqOS4i+S4gOWw
geeUteWtkOmCruS7tuS4reWRiuivieS9oOaIkeaYr+WmguS9leWBmuWIsOeahO+8jOS4jeimgeaD
iuaFjO+8jOS7luS7rOayoeaciemjjumZqe+8jOiAjOS4lOaIkei/mOWcqOS4jiBSZWQNCuacieiB
lOezu+eahOS6uumBk+S4u+S5ieWMu+eUn+eahOW4ruWKqeS4i+Wwhui/meeslOmSseWtmOWFpeS6
humTtuihjOOAguaIkeW4jOacm+aCqOWwhuiHquW3seS9nOS4uuaIkeeahOWPl+ebiuS6uuadpeaO
peaUtuWfuumHkeW5tuWcqOaIkeWcqOi/memHjOWujOaIkOWQjuehruS/neWug+eahOWuieWFqOW5
tuiOt+W+l+aIkeeahOWGm+S6i+mAmuihjOivgeS7peWcqOaCqOeahOWbveWutuS4juaCqOS8mumd
ou+8m+S4jeimgeWus+aAlemTtuihjOS8muWwhui1hOmHkeWtmOWCqOWcqA0KQVRNIFZJU0Eg5Y2h
5Lit77yM6L+Z5a+55oiR5Lus5p2l6K+05piv5a6J5YWo5LiU5b+r5o2355qE44CCDQoNCueslOiu
sDvmiJHkuI3nn6XpgZPmiJHku6zopoHlnKjov5nph4zlkYblpJrkuYXvvIzmiJHnmoTlkb3ov5Dv
vIzlm6DkuLrmiJHlnKjov5nph4zkuKTmrKHngrjlvLnooq3lh7vkuK3lubjlrZjkuIvmnaXvvIzo
v5nkv4Pkvb/miJHlr7vmib7kuIDkuKrlgLzlvpfkv6HotZbnmoTkurrmnaXluK7liqnmiJHmjqXm
lLblkozmipXotYTln7rph5HvvIzlm6DkuLrmiJHlsIbmnaXliLDkvaDku6znmoTlm73lrrblh7ro
uqvmipXotYTvvIzlvIDlp4vmlrDnlJ/mtLvvvIzkuI3lho3lvZPlhbXjgIINCg0K5aaC5p6c5oKo
5oS/5oSP6LCo5oWO5aSE55CG77yM6K+35Zue5aSN5oiR44CC5oiR5Lya5ZGK6K+J5L2g5LiL5LiA
5q2l55qE5rWB56iL77yM5bm257uZ5L2g5Y+R6YCB5pu05aSa5YWz5LqO5Z+66YeR5a2Y5YWl6ZO2
6KGM55qE5L+h5oGv44CC5Lul5Y+K6ZO26KGM5bCG5aaC5L2V5biu5Yqp5oiR5Lus6YCa6L+HIEFU
TSBWSVNBDQpDQVJEIOWwhui1hOmHkei9rOenu+WIsOaCqOeahOWbveWuti/lnLDljLrjgILlpoLm
npzkvaDmnInlhbTotqPvvIzor7fkuI7miJHogZTns7vjgIINCg==
