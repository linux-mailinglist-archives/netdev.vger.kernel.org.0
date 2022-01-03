Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55E44838C6
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 23:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiACWWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 17:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiACWWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 17:22:34 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42AC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 14:22:33 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id e25so27408048qkl.12
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 14:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ryYB5jKGadEi0k933ngWy9k9HXsrzqsuK+74anPVy+Y=;
        b=IY9YipjvM5M98QPKQw0ZEJTsQ2C5mnrNy45nfNhrfZxTP7J0X2rnVIXlFAJNeaPYbf
         6wnZPQw+iXk+7SKQl6MrsyJR+tIDbP83GshbGusNXLij1UFVy2azdw5MUn/1SkuWPYwy
         Mip3O+ILo1cUVh0RAQHNqeex8O9UrpgqraGlgC/SXawyJPD5vw/ybNfhNoPwc53rvSGS
         62Zi7CE81wJxI12TNR/AVxqi6M8vcFs9dx/cr11Ii9MGkxkoXKv8EmPNkPcTcHBYI+zD
         OqVb4WrBAfmOLSK/WFrNzpdCCmGI7qwBH9/SM0940adX+a5RYuD6Uuj8q/pSEqwnFYQh
         A1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ryYB5jKGadEi0k933ngWy9k9HXsrzqsuK+74anPVy+Y=;
        b=USP5Nw5HBedOUEcR5TTzs9wAA2A52aLdRIucqghJYi/tw87ijFGMt6FfYzBeZY/A9a
         o4cH7b7Rpiqg7yJJgU4um4eNhDS1uqQRbNnIihsLXQqYyYdSCeXc6JSxu12ySmEN93Mf
         uoQWgWwxxg89eHl1gQtRr2FYJxmM+CtW52hiIx2YP9Q8WDt0mKG6eEKBW76iCN+5PRVz
         l6XI4b0Q9p2JyC5LWjZwTNJZPWkw9s5BSbUeDkN5ctJ+1Q3Fj+6yrVtj1/XcJy3vOIFQ
         7CIjXMjeHT6y+lDL7Acio0NhWpNWGLQ0kmevBpbPF+c/CZfDXJfIdhSzxa8BsWAeyBhN
         S4KQ==
X-Gm-Message-State: AOAM533NhNgGIcQutfLY+pVjzRjsEXiIe5HCCrPBcYrnTHoJe6CdQ0t0
        rtUSey3LUrL0stWDpQr127VGGoX88mvc6cEt5AU=
X-Google-Smtp-Source: ABdhPJxVyTcs6/2ux31yIZmouwVqmjaidTQmMx1yYM7ejPsk4lYGhL5zRMsuCW0wJgygVgfjKfbTUe8jznTjkiyh4rM=
X-Received: by 2002:a05:620a:4441:: with SMTP id w1mr33907788qkp.619.1641248552787;
 Mon, 03 Jan 2022 14:22:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:622a:101:0:0:0:0 with HTTP; Mon, 3 Jan 2022 14:22:32
 -0800 (PST)
Reply-To: mstheresaheidi8@gmail.com
From:   Mrs Theresa Heidi <drsusanwilliams01@gmail.com>
Date:   Mon, 3 Jan 2022 22:22:32 +0000
Message-ID: <CAEkvORDZW3nxhUQwvvGFzYogKPavJXhQZq1Er1pcaypXmfxY6Q@mail.gmail.com>
Subject: =?UTF-8?B?55eF6Zmi44GL44KJ44Gu57eK5oCl44Gu5Yqp44GR?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

6Kaq5oSb44Gq44KL5oSb44GZ44KL5Lq644CBDQoNCuaFiOWWhOWvhOS7mOOBk+OBruaJi+e0meOB
jOOBguOBquOBn+OBq+mpmuOBjeOBqOOBl+OBpuadpeOCi+OBi+OCguOBl+OCjOOBquOBhOOBk+OB
qOOBr+eiuuOBi+OBp+OBmeOAgeazqOaEj+a3seOBj+iqreOCk+OBp+OBj+OBoOOBleOBhOOAguen
geOBr+OBguOBquOBn+OBruaPtOWKqeOCkuW/heimgeOBqOOBl+OBpuOBhOOCi+mWk+OBq+engeea
hOOBquaknOe0ouOCkumAmuOBl+OBpuOBguOBquOBn+OBrumbu+WtkOODoeODvOODq+OBrumAo+e1
oeWFiOOBq+WHuuOBj+OCj+OBl+OBvuOBl+OBn+OAguengeOBr+W/g+OBi+OCieaCsuOBl+OBv+OC
kui+vOOCgeOBpuOBk+OBruODoeODvOODq+OCkuabuOOBhOOBpuOBhOOBvuOBmeOAguOCpOODs+OC
v+ODvOODjeODg+ODiOOBjOS7iuOBp+OCguacgOmAn+OBruOCs+ODn+ODpeODi+OCseODvOOCt+OD
p+ODs+aJi+auteOBp+OBguOCi+OBn+OCgeOAgeOCpOODs+OCv+ODvOODjeODg+ODiOOCkuS7i+OB
l+OBpuOBguOBquOBn+OBq+mAo+e1oeOBmeOCi+OBk+OBqOOCkumBuOaKnuOBl+OBvuOBl+OBn+OA
gg0KDQrnp4Hjga7lkI3liY3jga/jg4bjg6zjgrXjg7vjg4/jgqTjgrjlpKvkurrjgafjgZnjgILn
p4Hjga/jg5Xjg6njg7Pjgrnlh7rouqvjgafjgZnjgILnj77lnKjjgIHjgZPjgZPjgqTjgrnjg6nj
gqjjg6vjga7np4Hnq4vnl4XpmaLjgavogrrjgYzjgpPjga7ntZDmnpzjgajjgZfjgablhaXpmaLj
gZfjgabjgYTjgb7jgZnjgILnp4Hjga82Muats+OBp+OAgee0hDTlubTliY3jgIHnp4Hjga7mrbvl
vozjgZnjgZDjgavogrrjgYzjgpPjgajoqLrmlq3jgZXjgozjgb7jgZfjgZ/jgILlvbzjgYzlg43j
gYTjgZ/jgZnjgbnjgabjgpLnp4HjgavmrovjgZfjgabjgY/jgozjgZ/lpKvjgILnp4Hjga/jgZPj
gZPjga7nl4XpmaLjgafjg6njg4Pjg5fjg4jjg4Pjg5fjgpLmjIHjgaPjgabjgYrjgorjgIHjgZ3j
gZPjgafogrrjgYzjgpPjga7msrvnmYLjgpLlj5fjgZHjgabjgYTjgb7jgZnjgILkuqHjgY/jgarj
gaPjgZ/lpKvjgYvjgonlj5fjgZHntpnjgYTjgaDos4fph5Hjga/jgIHnt4/poY0yNTDkuIfjg4nj
g6vvvIgyLDUwMCwwMDDnsbPjg4njg6vvvInjgZfjgYvjgYLjgorjgb7jgZvjgpPjgILku4rjgafj
ga/jgIHkurrnlJ/jga7ntYLjgo/jgorjgavov5HjgaXjgYTjgabjgYTjgovjgZPjgajjga/mmI7j
gonjgYvjgafjgIHjgoLjgYbjgZPjga7jgYrph5Hjga/lv4XopoHjgarjgYTjgajmgJ3jgYTjgb7j
gZnjgILnp4Hjga7ljLvogIXjga/jgIHnp4HjgYzogrrjgYzjgpPjga7llY/poYzjga7jgZ/jgoHj
gasx5bm06ZaT44Gv57aa44GL44Gq44GE44GT44Go44KS55CG6Kej44GV44Gb44Gm44GP44KM44G+
44GX44Gf44CCDQoNCuOBk+OBruOBiumHkeOBr+OBvuOBoOWkluWbveOBrumKgOihjOOBq+OBguOC
iuOAgee1jOWWtuiAheOBr+engeOCkuacrOW9k+OBruaJgOacieiAheOBqOOBl+OBpuOAgeOBiumH
keOCkuWPl+OBkeWPluOCi+OBn+OCgeOBq+WJjeOBq+WHuuOBpuadpeOCi+OBi+OAgeeXheawl+OB
ruOBn+OCgeOBq+adpeOCi+OBk+OBqOOBjOOBp+OBjeOBquOBhOOBruOBp+iqsOOBi+OBq+engeOB
q+S7o+OCj+OBo+OBpuWPl+OBkeWPluOCi+OBn+OCgeOBruaJv+iqjeabuOOCkueZuuihjOOBmeOC
i+OCiOOBhuOBq+abuOOBhOOBn+OAgumKgOihjOOBruihjOWLleOBq+WkseaVl+OBmeOCi+OBqOOA
geOBneOCjOOCkumVt+OBj+e2reaMgeOBl+OBn+OBn+OCgeOBq+izh+mHkeOBjOayoeWPjuOBleOC
jOOCi+WPr+iDveaAp+OBjOOBguOCiuOBvuOBmeOAgg0KDQrnp4HjgYzlpJblm73jga7pioDooYzj
gYvjgonjgZPjga7jgYrph5HjgpLlvJXjgY3lh7rjgZnjga7jgpLmiYvkvJ3jgaPjgabjgY/jgozj
govjgYvjgoLjgZfjgozjgarjgYTjgIHjgZ3jgZfjgaboiIjlkbPjgYzjgYLjgozjgbDjgIHnp4Hj
ga/jgYLjgarjgZ/jgavpgKPntaHjgZnjgovjgZPjgajjgavmsbrjgoHjgb7jgZfjgZ/jgILnp4Hj
gavkvZXjgYvjgYzotbfjgZPjgovliY3jgavjgIHjgZPjgozjgonjga7kv6HoqJfln7rph5HjgpLo
qqDlrp/jgavmibHjgaPjgabjgbvjgZfjgYTjgILjgZPjgozjga/nm5fjgb7jgozjgZ/jgYrph5Hj
gafjga/jgarjgY/jgIHlrozlhajjgarms5XnmoToqLzmi6DjgYzjgYLjgozjgbAxMDDvvIXjg6rj
grnjgq/jgYzjgarjgYTjgajjgYTjgYbljbHpmbrjga/jgYLjgorjgb7jgZvjgpPjgIINCg0K56eB
44Gv44GC44Gq44Gf44Gr44GC44Gq44Gf44Gu5YCL5Lq655qE44Gq5L2/55So44Gu44Gf44KB44Gr
57eP44GK6YeR44GuNDXvvIXjgpLlj5bjgorjgIHjgYrph5Hjga41Ne+8heOBjOaFiOWWhOS6i+al
reOBq+S9v+OCj+OCjOOCi+OBk+OBqOOCkuacm+OCk+OBp+OBhOOBvuOBmeOAguengeOBruacgOW+
jOOBrumhmOOBhOOCkuWNseOBhuOBj+OBmeOCi+OCguOBruOBr+S9leOCguacm+OCk+OBp+OBhOOB
quOBhOOBruOBp+OAgeengeOBruW/g+OBrumhmOOBhOOCkuWun+ePvuOBmeOCi+OBn+OCgeOBq+OA
geOBk+OBruWVj+mhjOOBq+WvvuOBmeOCi+OBguOBquOBn+OBruacgOWkp+mZkOOBruS/oemgvOOB
qOWuiOenmOe+qeWLmeOBq+aEn+isneOBl+OBvuOBmeOAguOCueODkeODoOOBp+OBk+OBruaJi+e0
meOCkuWPl+OBkeWPluOBo+OBn+WgtOWQiOOBr+OAgeeUs+OBl+ios+OBguOCiuOBvuOBm+OCk+OA
guOBk+OBruWbveOBp+OBruacgOi/keOBruaOpee2muOCqOODqeODvOOBjOWOn+WboOOBp+OBmeOA
gg0KDQrjgYLjgarjgZ/jga7mnIDmhJvjga7lprnjgIINCuODhuODrOOCteODj+OCpOOCuOWkq+S6
ug0K
