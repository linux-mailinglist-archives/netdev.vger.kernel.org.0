Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93401450958
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKOQQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhKOQQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:16:25 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5139FC061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:13:29 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d24so31829481wra.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=aEbkD0MZHqHf+9rUBNePxHoQt3EslhmQ3qory9m4aBw=;
        b=qJiQaeIuAgllVmJUuFNC1h5TImJDelh4OXDLlpZ7k+9WtKriPiDcrW/MPpghG12dMV
         KRE3VcWl/dT/QMyfLQ0qlaKJksIXCnscBmhIAgZVNFOa9iDG/DjINXbk8xpiISFArOEj
         kYtgW8KABZnJzqaE0bv5b7uZCJJHtnEKy1WBgt9AQRxV/aMw0DE7YAil3gFsVcwnyrVk
         Q9shymYqF7mlHGIMINkQWRcURE6D8Acx55fcqkIJ18r4OT3OOAix95M5T99/Pm6zF326
         7X/r/0Gs4jyKWBtUiG5QeuNxGLTttyGNAqKRA7G3UHXHY5flPBRAT3/TWtIwwXQCMKHi
         lP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=aEbkD0MZHqHf+9rUBNePxHoQt3EslhmQ3qory9m4aBw=;
        b=EtZbKfe6X5tTbKoiBAVsp4+Du2Uii5oADlN9rDS01jJXadFE+USp5FtMjtVS9l6+eu
         Gfe6zJfTmZ/lDpPiL7viDxENr7/k/+TSXhik3ZFOP4uZNqRSMemc+iHIG4SqXs4Lt3L9
         hH1GBH7F3eYqyt5n8+knHpkB9+A/FVFnbTFzmtdD6p1Ld1IHiGVXstVk+NH2RE8bTTLv
         hN0rNubQYehNPfteGW9HvU7AdXVdYVw3zlqbDVtFLy6pUbQJ7W+fH0LmfOF/Utwy2r5X
         9uoNholkSIYmK5IC0wiBK3vOS81PypItXsWngWT5iXUMyAB0pbMOh49bEgr/5iRebWv8
         n4sQ==
X-Gm-Message-State: AOAM530POyn8K24TgbLWXmr9vrzCXBkgrGp0xYnEmi9PdDSCmmrijx3c
        FWb+J0G8h4i1gfogCoirQePLMBsMfyeUuWUIqf0=
X-Google-Smtp-Source: ABdhPJzpazre36ajnqeMKpJTTSvuoiUqZAQG8M/SDoEhedZccCKfQLo4YmRHFwcStj73RgrphcxmakQ1whvWQzCJO6g=
X-Received: by 2002:adf:eb52:: with SMTP id u18mr226745wrn.90.1636992807928;
 Mon, 15 Nov 2021 08:13:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:6587:0:0:0:0:0 with HTTP; Mon, 15 Nov 2021 08:13:27
 -0800 (PST)
Reply-To: liampayen50@gmail.com
From:   liam payen <sankarahamadou9@gmail.com>
Date:   Mon, 15 Nov 2021 08:13:27 -0800
Message-ID: <CABmAao-5DU6qGHN8ywdYLzErFj_YW3o0AwnMXPRbHC=Fm_NV5A@mail.gmail.com>
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
5Zyo5Y+Z5Yip5Lqa77yM5LiO5oGQ5oCW5Li75LmJ5L2c5oiY44CC5oiR55qE5Y2V5L2N5piv56ys
NOaKpOeQhumYn+esrDc4MuaXheaUr+aPtOiQpeOAgg0KDQrmiJHmmK/kuIDkuKrlhYXmu6HniLHl
v4PjgIHor5rlrp7lkozmt7Hmg4XnmoTkurrvvIzlhbfmnInoia/lpb3nmoTlub3pu5jmhJ/vvIzm
iJHllpzmrKLnu5Por4bmlrDmnIvlj4vlubbkuobop6Pku5bku6znmoTnlJ/mtLvmlrnlvI/vvIzm
iJHllpzmrKLnnIvliLDlpKfmtbfnmoTms6LmtarlkozlsbHohInnmoTnvo7kuL3ku6Xlj4rlpKfo
h6rnhLbmiYDmi6XmnInnmoTkuIDliIfmj5DkvpvjgILlvojpq5jlhbTog73mm7TlpJrlnLDkuobo
p6PmgqjvvIzmiJHorqTkuLrmiJHku6zlj6/ku6Xlu7rnq4voia/lpb3nmoTllYbkuJrlj4vosIrj
gIINCg0K5oiR5LiA55u05b6I5LiN5byA5b+D77yM5Zug5Li66L+Z5Lqb5bm05p2l55Sf5rS75a+5
5oiR5LiN5YWs5bmz77yb5oiR5aSx5Y675LqG54i25q+N77yM6YKj5bm05oiRIDIxDQrlsoHjgILm
iJHniLbkurLlj6vkuZTlsJTCt+S9qeaBqe+8jOavjeS6suWPq+eOm+S4vcK35L2p5oGp44CC5rKh
5pyJ5Lq65biu5Yqp5oiR77yM5L2G5b6I6auY5YW05oiR57uI5LqO5Zyo576O5Yab5Lit5om+5Yiw
5LqG6Ieq5bex44CCDQoNCuaIkee7k+WpmueUn+S6huWtqeWtkO+8jOS9huS7luatu+S6hu+8jOS4
jeS5heaIkeS4iOWkq+W8gOWni+asuumql+aIke+8jOaJgOS7peaIkeS4jeW+l+S4jeaUvuW8g+Wp
muWnu+OAgg0KDQrlnKjmiJHnmoTlm73lrrbjgIHnvo7lm73lkozlj5nliKnkuprov5nph4zvvIzm
iJHkuZ/lvojlubjov5DvvIzmi6XmnInmiJHnlJ/mtLvkuK3miYDpnIDnmoTkuIDliIfvvIzkvYbm
sqHmnInkurrnu5nmiJHlu7rorq7jgILmiJHpnIDopoHkuIDkuKror5rlrp7nmoTkurrmnaXkv6Hk
u7vvvIzku5bkuZ/kvJrlsLHlpoLkvZXmipXotYTmiJHnmoTpkrHmj5Dkvpvlu7rorq7jgILlm6Dk
uLrmiJHmmK/miJHniLbmr43lnKjku5bku6zljrvkuJbliY3nlJ/kuIvnmoTllK/kuIDkuIDkuKrl
pbPlranjgIINCg0K5oiR5LiN6K6k6K+G5L2g5pys5Lq677yM5L2G5oiR6K6k5Li65pyJ5LiA5Liq
5YC85b6X5L+h6LWW55qE5aW95Lq677yM5LuW5Y+v5Lul5bu656uL55yf5q2j55qE5L+h5Lu75ZKM
6Imv5aW955qE5ZWG5Lia5Y+L6LCK77yM5aaC5p6c5L2g55yf55qE5pyJ5LiA5Liq6K+a5a6e55qE
5ZCN5a2X77yM5oiR5Lmf5pyJ5LiA5Lqb5Lic6KW/6KaB5ZKM5L2g5YiG5Lqr55u45L+h44CC5Zyo
5L2g6Lqr5LiK77yM5Zug5Li65oiR6ZyA6KaB5L2g55qE5biu5Yqp44CC5oiR5oul5pyJ5oiR5Zyo
5Y+Z5Yip5Lqa6L+Z6YeM6LWa5Yiw55qE5oC76aKd77yIMjUwDQrkuIfnvo7lhYPvvInjgILmiJHk
vJrlnKjkuIvkuIDlsIHnlLXlrZDpgq7ku7bkuK3lkYror4nkvaDmiJHmmK/lpoLkvZXlgZrliLDn
moTvvIzkuI3opoHmg4rmhYzvvIzku5bku6zmsqHmnInpo47pmanvvIzogIzkuJTmiJHov5jlnKjk
uI4gUmVkDQrmnInogZTns7vnmoTkurrpgZPkuLvkuYnljLvnlJ/nmoTluK7liqnkuIvlsIbov5nn
rJTpkrHlrZjlhaXkuobpk7booYzjgILmiJHluIzmnJvmgqjlsIboh6rlt7HkvZzkuLrmiJHnmoTl
j5fnm4rkurrmnaXmjqXmlLbln7rph5HlubblnKjmiJHlnKjov5nph4zlrozmiJDlkI7noa7kv53l
roPnmoTlronlhajlubbojrflvpfmiJHnmoTlhpvkuovpgJrooYzor4Hku6XlnKjmgqjnmoTlm73l
rrbkuI7mgqjkvJrpnaLvvJvkuI3opoHlrrPmgJXpk7booYzkvJrlsIbotYTph5HlrZjlgqjlnKgN
CkFUTSBWSVNBIOWNoeS4re+8jOi/meWvueaIkeS7rOadpeivtOaYr+WuieWFqOS4lOW/q+aNt+ea
hOOAgg0KDQrnrJTorrA75oiR5LiN55+l6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5ZGG5aSa5LmF77yM
5oiR55qE5ZG96L+Q77yM5Zug5Li65oiR5Zyo6L+Z6YeM5Lik5qyh54K45by56KKt5Ye75Lit5bm4
5a2Y5LiL5p2l77yM6L+Z5L+D5L2/5oiR5a+75om+5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l
5biu5Yqp5oiR5o6l5pS25ZKM5oqV6LWE5Z+66YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw5L2g5Lus
55qE5Zu95a625Ye66Lqr5oqV6LWE77yM5byA5aeL5paw55Sf5rS777yM5LiN5YaN5b2T5YW144CC
DQoNCuWmguaenOaCqOaEv+aEj+iwqOaFjuWkhOeQhu+8jOivt+WbnuWkjeaIkeOAguaIkeS8muWR
iuivieS9oOS4i+S4gOatpeeahOa1geeoi++8jOW5tuWPkemAgeabtOWkmuWFs+S6juWfuumHkeWt
mOWFpemTtuihjOeahOS/oeaBr+OAguS7peWPiumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmA
mui/hyBBVE0gVklTQQ0KQ0FSRCDlsIbotYTph5Hovaznp7vliLDmgqjnmoTlm73lrrYv5Zyw5Yy6
44CC5aaC5p6c5L2g5pyJ5YW06Laj77yM6K+35LiO5oiR6IGU57O744CCDQo=
