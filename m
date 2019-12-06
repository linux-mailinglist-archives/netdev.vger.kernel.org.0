Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CA1115020
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 13:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLFMBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 07:01:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34015 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfLFMBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 07:01:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id f4so9628741wmj.1
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 04:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XsEd9Nv1AeqU19tKr7PslEXD3w/51iBx3qBKIaqWrTs=;
        b=qZ/ttOuI6dsqX3Kclr+UB91lLxnxY6MTnyO38gEzIpQJkE6o5ysejxvEj824Z4QGeb
         frYrsWXIe77CzMbys7LNGr5yxELA+MI9BFvEqil5/j/4Kp6tm/6HczEVaXMAbRwxr5VY
         c4ryEHpOiaNUYkzS3U3mvkAJrjo318dRJRnQRXrt4pC9OGBHFFpQ/FdiNYbgyO/OcxsK
         Wo4ZOZ6Jw01EKE5MzfvRolzWPf7PIx9qb09MQrl0gQgK2abf7lD1GD1iouiSaILdqJML
         ClN1RoQ/GkFqXvUyUfLl8dWxBg7m4eHfrdn7c/7XGCVewoEWUozX7+abOphlpp+YTjOr
         s9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XsEd9Nv1AeqU19tKr7PslEXD3w/51iBx3qBKIaqWrTs=;
        b=EpYj61+S6iPGFwzw6pFR0nbi+zuhr7mY86lX9RpBGEPP9P3pfZp+2xnJziDshfr1+E
         BNYHhIf1ig9KCtKVTolMKbh10oJ3U7tUfEfQC4GyPW5WYw2dcGav8osS+zA3GOeRlDvc
         6eyOrCLSu0hIL7jquu5WC0LyDwIkX2PRLNvhRspsmpAOWDVu5TdkNTPeQy7Dh9y1njsZ
         T3C5RVeYJ5+B2OqKtnkLVy4XMyLsyzoEZRzrub7QIlU5hOsrTfXR2kyCry5DjTnQTAkj
         C76uv+ihaxIGoGRvQUpeC92tcypg4r5bQF2bQSze016Ko8kzxcoGbTL6awE30jZhxciM
         pYIw==
X-Gm-Message-State: APjAAAXBUepTsxHeio5pyqlUrVwy7OMCSTW1FXjgoGdPY17gNvyTh9/v
        geeqQ4M8eZKzKPoUh8ATJWiKuGsPKQWND2IQbAM=
X-Google-Smtp-Source: APXvYqz/6o8uG7XJ7t7oFtxU1Ep1jzyiDuuCFMXJGei0iaAXTPgMVgMEAizMAFmR6loEm1vrPgqpfMSN2l+0xON9BPk=
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr10276437wmk.116.1575633664915;
 Fri, 06 Dec 2019 04:01:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a1c:e303:0:0:0:0:0 with HTTP; Fri, 6 Dec 2019 04:01:04 -0800 (PST)
Reply-To: mis.mariam.maalouf3@gmail.com
From:   Mis Mariam Maalouf <douglasmarkfrank355@gmail.com>
Date:   Fri, 6 Dec 2019 13:01:04 +0100
Message-ID: <CAHJWG19qp96GQRJWMPhWiqqW=Mb32_APO26FYEYp4kxRHprXfg@mail.gmail.com>
Subject: =?UTF-8?B?6Kaq5oSb44Gq44KL5Y+L5Lq644G444Gu5oyo5ou244CB?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

6Kaq5oSb44Gq44KL5Y+L5Lq644G444Gu5oyo5ou244CBDQoNCuengeOBruWQjeWJjeOBr+ODnuOD
quOCouODoOODu+ODnuOCouODreODleOBp+OBmeOAgua2meOCkua1geOBl+OBquOBjOOCieOBk+OB
ruODoeODg+OCu+ODvOOCuOOCkuabuOOBhOOBpuOBhOOBvuOBmeOAguengeOBruWbveOBp+mAsuih
jOS4reOBruWGheaIpuOCt+ODquOCouOBr+engeOBruS6uueUn+OBq+Wkp+OBjeOBquW9semfv+OC
kuS4juOBiOOBvuOBl+OBn+OAguWOu+W5tOWutuaXj+OCkuWkseOBhOOBvuOBl+OBn+OAgueItuOB
r+S6oeOBj+OBquOCi+WJjeOBr+mHkeaMgeOBoeOBp+OAgeefs+ayueOBqOOCrOOCueOBruODk+OC
uOODjeOCueOCkuOBl+OBpuOBhOOBpuOAgemHkeOBruODk+OCuOODjeOCueOCguOBl+OBpuOBhOOB
n+OAguW9vOOBr+Wkp+mHkeOCkueovOOBhOOBoO+8iDI1MDDkuIczMDAw44OJ44Or77yJ44K344Oq
44Ki44Gn44Gu5oim5LqJ44Go5q665a6z44CCDQoNCuengeOBjOeXheawl+OBi+OCieWbnuW+qeOB
l+OAgeOBguOBquOBn+OBq+S8muOBhOOBq+adpeOCi+OBvuOBp+OAgeengeOBr+OBguOBquOBn+OB
jOengeOBjOOBiumHkeOCkuWPl+OBkeWPluOCi+OBruOCkuaJi+S8neOBhuW/heimgeOBjOOBguOC
iuOBvuOBmeOAgg0KDQrnp4Hjga/kuqHjgY3niLbjga7jg5Pjgrjjg43jgrnjg5Hjg7zjg4jjg4rj
g7zjgajjgZfjgabjgYLjgarjgZ/jgpLku7vlkb3jgZfjgZ/jgYTjgajmgJ3jgYTjgb7jgZnjgILj
gYrph5HjgpLpoJDjgZHjgovjgZ/jgoHjga7jgZnjgbnjgabjga7mm7jpoZ7jgajmg4XloLHjgpLj
gYrpgIHjgorjgZfjgb7jgZnjgIINCg0K44GC44Gq44Gf44GM56eB44Gu44Gf44KB44Gr44GT44KM
44KS6KGM44GG44GT44Go44GM44Gn44GN44KL44GL44Gp44GG44GL56eB44Gr55+l44KJ44Gb44Gm
44GP44Gg44GV44GE44CB44GT44KM44Gv56eB44Gu5pys5b2T44Gu6Kmx44Gn44GZ44CB56eB44Gv
44GC44Gq44Gf44Gu5Yqp44GR44GM5b+F6KaB44Gn44GZDQoNCuOBguOBquOBn+OBr+engeOBruOD
oeODvOODq++8iG1pcy5tYXJpYW0ubWFhbG91ZjJAZ21haWwuY29t77yJ44Gn56eB44Gr6YCj57Wh
44GZ44KL44GT44Go44GM44Gn44GN44G+44GZDQoNCuaVrOWFt+OAgQ0KDQpNaXMgTWFyaWFtIE1h
YWxvdWYNCg==
