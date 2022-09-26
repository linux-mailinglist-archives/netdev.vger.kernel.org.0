Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD445EAE4F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiIZRja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiIZRjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:39:14 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD278476E1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:03:13 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id g85so3716788vkf.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=NL2j5GnRtPSyJoYbxDPwesH3P6+XcidREgbhHvhd444=;
        b=OtHcB7p0IX16Xu0xQXhVAzW3kpo84BNEgKVdt4KpmXxx5lUMkxw3hoXkcq8nZ7sape
         lfcqOTRiACBpC+PKNwziwRhbA9E2qe2xmseno66S3L+f5AZKYpsgkDOnaFNDzJ1/Yy6e
         11lwfDD7VGAWmFJxRJNLprztBZQUYk/l4kuv0EMUB/5bovyFq4SOGZEzZn/tDYfD9sCn
         S6AtI79mzm543wgKD78+rJTwPap9klCXHpkSwwGvOYH9Y2x4/KqgaABp/zEg/jprqeeh
         bWb9GzPTCcrMqLIO1Ms+OghsONCk4RpJ+9X2yikeLdAJLh/m/vitRJQ8ZAsQ0j2ies3s
         1nKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NL2j5GnRtPSyJoYbxDPwesH3P6+XcidREgbhHvhd444=;
        b=m+NagjWbEgkR/zZ5TBDjyYK4hhIbvW2IU55H7LU+hOJU+Tck6LtRuWhcCAv319oEbv
         BHWOD9+LTvbx7aPIILwTK7MntsPBxS2N1tAM6laY5WzVec9OT1VVqrXAXDO1owIm19+n
         55tLQeOv5XYznpP5pr2TNO3taTPh6PAUIbviIphyBegB6vpGwFTukdUm0/jCemy+EJuY
         PUeNqh0iSZtNECPMY7dK408Hy1MoGG4gdQpy9OCIH7c3uhG2soz6sB05lx5RRAvFh6I/
         7R1TaP7YVEiei96zC6VIpUsjhhUTuLu/i3+Et9wrZ+fWymLaHAE8AZesAk7tvekoG6pw
         dbmA==
X-Gm-Message-State: ACrzQf3Qu/Fh8NeeM4/yoYWg6ibEkqNPxQ5oYgEJosWpQ7sRgAvS65EL
        d8CoSXWumoYAl7glF9yhLO1NQkI1wEXQrnD7v2k=
X-Google-Smtp-Source: AMsMyM6ghXxvURqA6P6zMSpEq9jorIjW8AOnpoVWOTxbFW1uBFieEHo/EtaRw/Gljoa52r2XsEGYqiViTczJk3/Fpho=
X-Received: by 2002:a1f:78c1:0:b0:3a3:72e6:c482 with SMTP id
 t184-20020a1f78c1000000b003a372e6c482mr9493349vkc.10.1664211789735; Mon, 26
 Sep 2022 10:03:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6130:11f:b0:382:f28c:9768 with HTTP; Mon, 26 Sep 2022
 10:03:09 -0700 (PDT)
From:   Ajfor simon <lawyersimon1985@gmail.com>
Date:   Mon, 26 Sep 2022 17:03:09 +0000
Message-ID: <CAN9gDKf2xmr0XC5+iT9HNejG4PG-vOGx4pSSE=_uFD+Y=fhYTQ@mail.gmail.com>
Subject: =?UTF-8?B?7JeQ6rKMLCBLYW5n?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7JeQ6rKMLCBLYW5nDQoNCuyViOuFle2VmOyEuOyalC4g7KCA64qUIOyEnOyVhO2UhOumrOy5tCDr
oZzrqZQg7Yag6rOg7JeQ7IScIOuzgO2YuOyCrOuhnCDsnbztlZjripQg67OA7Zi47IKs7J24IFNp
bW9uIEFqYeyeheuLiOuLpC4gRW5nci5HZW9yZ2UgS2FuZ+ydmA0K6rCc7J24IOuzgO2YuOyCrOuK
lCDroZzrqZQg7Yag6rOgIOyEnOu2gCDslYTtlITrpqzsubTsnZgg7ImYIOqwnOuwnCDtmozsgqzs
l5DshJwg6rOE7JW97J6QIOuwjyDshJ3snKAg7Iuc7LaUIOyDge2SiOycvOuhnCDsnbztlojrjZgg
7KCB7J20IOyeiOyKteuLiOuLpC4g6re464qUDQoyMDIw64WEIDEx7JuUIDIx7J287JeQIOyCrOun
ne2WiOyKteuLiOuLpC4g6re47J2YIOyVhOuCtOyZgCDsmbjrj5nrlLjsnbQg66+46rWt7JeQ7ISc
IOy9lOu5hOuTnC0xOeuhnCDsgqzrp53tlZwg7ZuEIOyLrOyepeuniOu5hDsNCg0K6re4IOydtO2b
hOuhnCDsoIDripQg7KCcIOqzoOqwneydmCDsuZzsspnsnYQg7LC+6riwIOychO2VtCDsl6zquLAg
7Yag6rOg7JeQIOyeiOuKlCDri7nsi6DsnZgg64yA7IKs6rSA7JeQIOusuOydmO2VtCDsmZTsirXr
i4jri6QuIOydtOqyg+ydgCDrmJDtlZwg7ISx6rO17KCB7J207KeAIOyViuydgA0K6rKD7Jy866Gc
IO2MkOuqheuQmOyXiOycvOupsCwg7KCA64qUIOuKpuydgCDqs6DqsJ3snbQg64Ko6rKo65GUIOuv
uO2ZlCAxLDI1MOunjCDri6zrn6wg7IOB64u57J2YIOq4sOq4iOydhCDrs7jqta3snLzroZwg7Iah
7ZmY7ZWY64qUIOuNsCDrj4Tsm4DsnYQg7KO86riwIOychO2VtA0K6reA7ZWY7JeQ6rKMIOyXsOud
ve2WiOyKteuLiOuLpC4NCuqzpyDri7nsi6Dsl5DqsozshJwg7IaM7Iud7J2EIOq4sOuLpOumrOqz
oA0KDQrsuZzslaDtlZjripQuDQrrs4DtmLjsgqwgU2ltb24gQWphZm9yKEVTUSkNCuuhnOuplCDt
hqDqs6Ag7ISc7JWE7ZSE66as7Lm0DQo=
