Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50710ADB9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfK0KaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:30:19 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37361 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfK0KaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 05:30:18 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so20703614qtk.4
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 02:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4Ny9bCRzlSL5kowE78lFJFmlCaKa69/ARy6t4b8d2kE=;
        b=XsjcBsVdGE70c7GiZDyTA5zEs14DI6vvCVucen59YaKbegR3TMEJlpk9VU6fBOJ7sj
         SIB6Ur4ZqHzSBHhn1xfsE0JMno5o28/xTlca/0EOwr9JaxmSBCyTVH5Yu1Vt76VDorgI
         f1Uebq1/cbEaSw40k/4AZO70+XWys5djBgAVDLkbU243cvcziBsZU3ofofAwAC/CQJXi
         NW/g47FbeUSw3Ecu1CsHxhyczPG2clTWf9wXAP0MR4q+6rA7qztdUzJI7RIG0wOILawB
         aKSPcA5yal7jOrsMMai1qugPns7FfFTKR/Ft4j9CIPRl5Hc3d3PdENNmeq9Lb71aO4V2
         LRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4Ny9bCRzlSL5kowE78lFJFmlCaKa69/ARy6t4b8d2kE=;
        b=RgYQ3bTIq3XIt1A14nrcAyLuaNV5EJNtLdJpiKlvRkFxz2RtdegNJJYAZ9qrbGZVug
         HjyT78xmzuhBvhZfG+TmIYJC/R3eDsFspBGXBHUbg7jswRM4DSwosdPmSdQsc0IgFeX7
         4SeWx20sOGaN3USSew2yA6WCveo9HN/SiWWpvYj04MzhimeHNSX8iqRmhnCShG7WL0vz
         67+LE1zFYAGsot8jdrzJh0xFK9ziGeR7dcI1sAAGdzb6OMOAnQB/bf3WttJ/jqTgwIKg
         9R4szL+yw8a7TwqNvEYe73OppS8Ix+boqzVStKJw0PheMIv/rkyExon/3kWUBbh9a+uH
         et1Q==
X-Gm-Message-State: APjAAAXtWFRKKcoUHcjdRiPsZjS2Uanhys0cpQPzapVbIL9NnibANQBX
        lBTIAnN/iYTnClBRQeBHQJ7R7gAUxq8rd2MXe0I=
X-Google-Smtp-Source: APXvYqzxWnOkxPT67rj6NBdc6uqART/O6XZWBD841MA9xkD3Wwdv80m8wLymCmkWirykFUwcUTZOnEGV8rjmpItLDrk=
X-Received: by 2002:ac8:e4a:: with SMTP id j10mr24098337qti.340.1574850617631;
 Wed, 27 Nov 2019 02:30:17 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:e88b:0:0:0:0:0 with HTTP; Wed, 27 Nov 2019 02:30:17
 -0800 (PST)
Reply-To: mariamabdul002@gmail.com
From:   Mariam Abdul <victorjames147700@gmail.com>
Date:   Wed, 27 Nov 2019 18:30:17 +0800
Message-ID: <CAAX-fs7m97OHE5k=ZTO8WFt0+Xe5AW0S-nsmbvHnZEaxe1jcug@mail.gmail.com>
Subject: =?UTF-8?B?6Kaq5oSb44Gq44KL5Y+L5Lq644G444Gu5oyo5ou244CB?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

6Kaq5oSb44Gq44KL5Y+L5Lq644G444Gu5oyo5ou244CBDQoNCuengeOBruWQjeWJjeOBr+ODnuOD
quOCouODoOODu+OCouODluODieOCpeODq+OBp+OBmeOAgua2meOCkua1geOBl+OBquOBjOOCieOB
k+OBruODoeODg+OCu+ODvOOCuOOCkuabuOOBhOOBpuOBhOOBvuOBmeOAguengeOBruWbveOCt+OD
quOCouOBp+mAsuihjOS4reOBruWGheaIpuOBr+engeOBruS6uueUn+OBq+Wkp+OBjeOBquW9semf
v+OCkuS4juOBiOOBvuOBl+OBn+OAguWOu+W5tOWutuaXj+OCkuWkseOBhOOBvuOBl+OBn+OAguen
geOBrueItuOBr+atu+OBrOWJjeOBr+mHkeaMgeOBoeOBp+OAgeefs+ayueOBqOOCrOOCueOBruOD
k+OCuOODjeOCueOCkuOBl+OBpuOBhOOBpuOAgemHkeOBruODk+OCuOODjeOCueOCguOBl+OBpuOB
hOOBvuOBl+OBn+OAguW9vOOBr+Wkp+mHkeOCkueovOOBhOOBoO+8iDI1MDDkuIczMDAw44OJ44Or
77yJ44K344Oq44Ki44Gn44Gu5oim5LqJ44Go5q665a6z44CCDQoNCuengeOBjOeXheawl+OBi+OC
ieWbnuW+qeOBl+OAgeOBguOBquOBn+OBq+S8muOBhOOBq+adpeOCi+OBvuOBp+OAgeengeOBr+OB
guOBquOBn+OBjOengeOBjOOBiumHkeOCkuWPl+OBkeWPluOCi+OBruOCkuaJi+S8neOBhuW/heim
geOBjOOBguOCiuOBvuOBmeOAgg0KDQrnp4Hjga/kuqHjgY3niLbjga7jg5Pjgrjjg43jgrnjg5Hj
g7zjg4jjg4rjg7zjgajjgZfjgabjgYLjgarjgZ/jgpLku7vlkb3jgZfjgZ/jgYTjgajmgJ3jgYTj
gb7jgZnjgILjg4njg5DjgqTjga7nrKzkuIDmub7lsrjpioDooYzjga/jgYLjgarjgZ/jgavjgYrp
h5HjgpLpgIHph5HjgZfjgb7jgZnjgILjgYrph5HjgpLpoJDjgZHjgovjgZ/jgoHjga7mm7jpoZ7j
gajmg4XloLHjgpLjgZnjgbnjgabjgYrpgIHjgorjgZfjgb7jgZnjgIINCg0K44GC44Gq44Gf44GM
56eB44Gu44Gf44KB44Gr44GT44KM44KS6KGM44GG44GT44Go44GM44Gn44GN44KL44GL44Gp44GG
44GL56eB44Gr55+l44KJ44Gb44Gm44GP44Gg44GV44GE44CB44GT44KM44Gv56eB44Gu5pys5b2T
44Gu6Kmx44Gn44GZ44CB56eB44Gv44GC44Gq44Gf44Gu5Yqp44GR44GM5b+F6KaB44Gn44GZ44CC
DQoNCuengeOBruODoeODvOODq++8iG1pc21hcmlhbWFiZHVsQGdtYWlsLmNvbe+8ieOBp+engeOB
q+mAo+e1oeOBp+OBjeOBvuOBmQ0KDQrmlazlhbfjgIENCg0KTWFyaWFtIEFiZHVsDQo=
