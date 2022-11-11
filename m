Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34636262BD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiKKUVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiKKUVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:21:40 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C272186C7
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:21:40 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id v8so1724422uap.12
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+VoC5O6h7ZfIBAy9yt0jFTh5sWdzWSPpFHMVA1UnB6o=;
        b=fBzUIv9uPPIrcuGadXPzSlLXe/vC/q4HXsus/Y/0pRVZ8LNAMD3XcuFO2roqcnLxmH
         5b83otB7tFdqKwkKmYQaYlLHcKxoozyCNlAew84q/t0Xd9rowNbjv+/tM1JsKr6WQIAQ
         HxMokgm+H1weUM+IRlgnB3/WuDn8LMa5IFTdVpqCSil9wjhGqEf3wwSEXqSbKsUZnLg8
         UmiGM5rOJcJ3WBVMncy7b8PHbROSxZZRAQz9t2+ciCBLaobc6XLgWG6IP1P82Xixn2xO
         xNlmZWDXnRI2WK010f2t/aGakpQCvp1TuVd0rLUW4WaIKb7cKpgv1sYU3HM2j7/uEaFr
         F0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VoC5O6h7ZfIBAy9yt0jFTh5sWdzWSPpFHMVA1UnB6o=;
        b=6kxf8pKZ3OfeX/xcs68HxSjSP4Z99kE+UZLuOUUJ5VovWoPnES2XGzWq9e26Z5ESvy
         n2zTmq9OkXjWnyggZWn+MXqIi4r8pbJXDF66Uihgz+X5utqutm6CioU3J0JtyuWSP/aS
         SMb+Rct5/rLNY9D2IzZVjV08PITpLDAGXkAmqh8CF8i+z517Xb6YWJiuZG8gaB+awGXu
         eJ1teti32TBCRsjcSDF1EIBWaEpKDrhBOba0ZbjsZqIxGnPCkxOR9n8hWgw1CUrIPO7r
         FBgLo3nO8NfP8GdaEu5rWtAELr6z0QAAMu/ByRZj6EZRfvuX/uUQ8p7iYi23MaFVUDie
         ADBA==
X-Gm-Message-State: ANoB5pnxaJFXwPfCFr6kFPfUkilvvc/TwsQqaqaAw0h9mTJX/db/hCXp
        brlE11fazWmwBz3S670JIS2HUiAM2NClyDAX5uk=
X-Google-Smtp-Source: AA0mqf5vKS5EgpVqE+VoVoeiIk1nqGBwLYHp21UIalcpOiVGh0QDL3P5YaRGsxrmAPoNKiSrCuap4TM5Sq1rRFieqK0=
X-Received: by 2002:ab0:74ce:0:b0:408:6592:3be6 with SMTP id
 f14-20020ab074ce000000b0040865923be6mr1786312uaq.103.1668198099034; Fri, 11
 Nov 2022 12:21:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6102:98:0:0:0:0 with HTTP; Fri, 11 Nov 2022 12:21:38
 -0800 (PST)
Reply-To: mrstheresaheidi8@gmail.com
From:   "Ms. Theresa Heidi" <isaacibrahim942@gmail.com>
Date:   Fri, 11 Nov 2022 12:21:38 -0800
Message-ID: <CAC5HyG76JXfJ4s5zHDmd4_yahZ9xunLQOTMkCQL4u4C3CBuXRg@mail.gmail.com>
Subject: =?UTF-8?B?56eB44KS5Yqp44GR44Gm44GP44Gg44GV44GE?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:934 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [isaacibrahim942[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [isaacibrahim942[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrstheresaheidi8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5oWI5ZaE5a+E5LuY77yBDQoNCuazqOaEj+a3seOBj+OBiuiqreOBv+OBj+OBoOOBleOBhOOAguOB
k+OBruaJi+e0meOBjOOBguOBquOBn+OBq+OCteODl+ODqeOCpOOCuuOBqOOBl+OBpuWxiuOBj+OB
i+OCguOBl+OCjOOBquOBhOOBk+OBqOOBr+S6i+Wun+OBp+OBmeOAguOBguOBquOBn+OBruWKqeOB
keOBjOW/heimgeOBquOBqOOBjeOBq+OAgeODl+ODqeOCpOODmeODvOODiOaknOe0ouOBp+OBguOB
quOBn+OBrumbu+WtkOODoeODvOODq+mAo+e1oeWFiOOBq+WHuuS8muOBhOOBvuOBl+OBn+OAguen
geOBr+W/g+OBruS4reOBp+OBk+OBruODoeODvOODq+OCkuabuOOBhOOBpuOBhOOBvuOBmeOBjOOA
geOCpOODs+OCv+ODvOODjeODg+ODiOOBr+S+neeEtuOBqOOBl+OBpuacgOmAn+OBrumAmuS/oeaJ
i+auteOBp+OBguOCi+OBn+OCgeOAgeOCpOODs+OCv+ODvOODjeODg+ODiOOCkuS7i+OBl+OBpuOB
guOBquOBn+OBq+mAo+e1oeOBmeOCi+OBk+OBqOOCkumBuOaKnuOBl+OBvuOBl+OBn+OAgg0KDQrn
p4Hjga/nj77lnKjjgIHogrrjgYzjgpPjga7jgZ/jgoHjgqTjgrnjg6njgqjjg6vjga7np4Hnq4vn
l4XpmaLjgavlhaXpmaLjgZfjgabjgYTjgosgNjINCuats+OBruODhuODrOOCteODj+OCpOOCuOWk
q+S6uuOBp+OBmeOAguengeOBrzTlubTliY3jgIHjgZnjgbnjgabjgpLmrovjgZfjgabjgY/jgozj
gZ/lpKvjgYzkuqHjgY/jgarjgaPjgZ/nm7TlvozjgavogrrjgYzjgpPjgajoqLrmlq3jgZXjgozj
gb7jgZfjgZ/jgILnp4Hjga/jgIHogrrjgYzjgpPjga7msrvnmYLjgpLlj5fjgZHjgabjgYTjgovn
l4XpmaLjgafjg6njg4Pjg5fjg4jjg4Pjg5fjgpLmjIHjgaPjgabjgYTjgb7jgZnjgIINCg0K56eB
44Gv5Lqh44GP44Gq44Gj44Gf5aSr44GL44KJ5Y+X44GR57aZ44GE44Gg6LOH6YeR44KS5oyB44Gj
44Gm44GE44G+44GZ44CC44Gd44Gu57eP6aGN44Gv44Gf44Gj44Gf44GuIDEyMCDkuIfjg4njg6sN
CigxMuWEhOexs+ODieODqynjgafjgZnjgILku4rjgIHnp4HjgYzkurrnlJ/jga7mnIDlvozjga7m
l6Xjgavov5HjgaXjgYTjgabjgYTjgovjgZPjgajjga/mmI7jgonjgYvjgafjgZnjgILjgZPjga7j
gYrph5Hjga/jgoLjgYblv4XopoHjgarjgYTjgajmgJ3jgYTjgb7jgZnjgIIu56eB44Gu5Li75rK7
5Yy744Gv44CB56eB44GM6IK644GM44KT44Gu5ZWP6aGM44Gu44Gf44KB44GrDQoxIOW5tOmWk+OB
r+eUn+OBjeOCieOCjOOBquOBhOOBk+OBqOOCkueQhuino+OBleOBm+OBvuOBl+OBn+OAgg0KDQrj
gZPjga7jgYrph5Hjga/jgb7jgaDlpJblm73jga7pioDooYzjgavkv53nrqHjgZXjgozjgabjgYrj
gorjgIHntYzllrbpmaPjga/jgIHnp4HjgYznl4XmsJfjga7jgZ/jgoHjgavmnaXjgovjgZPjgajj
gYzjgafjgY3jgarjgYTjga7jgafjgIHjgYrph5HjgpLlj5fjgZHlj5bjgovjgZ/jgoHjgavliY3j
gavmnaXjgovjgYvjgIHku6Pjgo/jgorjgavoqrDjgYvjgavjgYrph5HjgpLlj5fjgZHlj5bjgovj
gZ/jgoHjga7mib/oqo3mm7jjgpLnmbrooYzjgZnjgovjgojjgYbjgavjgIHnnJ/jga7miYDmnIno
gIXjgajjgZfjgabnp4HjgavmiYvntJnjgpLmm7jjgY3jgb7jgZfjgZ/jgIIu6YqA6KGM44Gu6KGM
5YuV44KS5oCg44KL44Go44CB6LOH6YeR44KS6ZW35pyf6ZaT5L+d566h44GX44Gf44Gf44KB44Gr
6LOH6YeR44GM5rKh5Y+O44GV44KM44KL5Y+v6IO95oCn44GM44GC44KK44G+44GZ44CCDQoNCuOB
k+OBruOBiumHkeOCkuWkluWbveOBrumKgOihjOOBi+OCieW8leOBjeWHuuOBl+OBpuOAgeaBteOB
vuOCjOOBquOBhOS6uuOAheOCkuWKqeOBkeOCi+ODgeODo+ODquODhuOCo+ODvOa0u+WLleOBq+iz
h+mHkeOCkuS9v+eUqOOBmeOCi+OBruOCkuaJi+S8neOBo+OBpuOBj+OCjOOCi+OBi+OBqeOBhuOB
i+OAgeOBneOBl+OBpuiIiOWRs+OBjOOBguOCi+OBquOCieOAgeengeOBr+OBguOBquOBn+OBq+mA
o+e1oeOBmeOCi+OBk+OBqOOBq+axuuOCgeOBvuOBl+OBny7np4HjgavkvZXjgYvjgYzotbfjgZPj
govliY3jgavjgIHjgZPjgozjgonjga7kv6HoqJfln7rph5HjgpLoqqDlrp/jgavlh6bnkIbjgZfj
gabjgbvjgZfjgYQu44GT44KM44Gv55uX44G+44KM44Gf44GK6YeR44Gn44Gv44Gq44GP44CB5a6M
5YWo44Gq5rOV55qE6Ki85oug44GM44GC44KK44CBMTAwJQ0K44Oq44K544Kv44GM44Gq44GP44CB
5Y2x6Zm644Gv44GC44KK44G+44Gb44KT44CCDQoNCuOBiumHkeOBriA1NSUg44Gv5oWI5ZaE5rS7
5YuV44Gr5L2/44KP44KM44CB5ZCI6KiI6YeR6aGN44GuIDQ1JQ0K44Gv44GC44Gq44Gf44Gu5YCL
5Lq655qE44Gq5L2/55So44Gu44Gf44KB44Gr5Y+W44Gj44Gm44G744GX44GELuengeOBr+engeOB
ruacgOW+jOOBrumhmOOBhOOCkuWNsemZuuOBq+OBleOCieOBmeOCiOOBhuOBquOBk+OBqOOBr+S9
leOCguacm+OCk+OBp+OBhOOBquOBhOOBruOBp+OAgeengeOBruW/g+OBi+OCieOBrumhmOOBhOOC
kumBlOaIkOOBmeOCi+OBn+OCgeOBq+OAgeOBguOBquOBn+OBruacgOWkp+mZkOOBruS/oemgvOOB
qOenmOWvhuS/neaMgeOBq+aEn+isneOBl+OBvuOBmS7jgZPjga7miYvntJnjgpLov7fmg5Hjg6Hj
g7zjg6vjgaflj5fjgZHlj5bjgaPjgZ/loLTlkIjjga/jgIHnlLPjgZfoqLPjgYLjgorjgb7jgZvj
gpPjgYzjgIHjgZPjgozjga/jgZPjga7lm73jgafjga7mnIDov5Hjga7mjqXntprjgqjjg6njg7zj
gavjgojjgovjgoLjga7jgafjgZnjgIINCg0K44GC44Gq44Gf44Gu5pyA5oSb44Gu5aa544CCDQrj
g4bjg6zjgrXjg7vjg4/jgqTjgrjlpKvkuroNCg==
