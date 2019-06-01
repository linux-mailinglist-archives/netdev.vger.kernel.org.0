Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C0E31A93
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 10:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFAIhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 04:37:40 -0400
Received: from mout.web.de ([217.72.192.78]:37309 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfFAIhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 04:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559378254;
        bh=A2n9kAcES47/+bnZaoJNCVg0H4NW/A4A8Mo34xdoI5s=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=n2LRLS4L7+ZcfZepwiFtpMb6W0DU2Jt1IqTALuD6hChP5d/fSHXGJXXUb/SMGRQzg
         BasSLYHwQYU4fv/78A1EUuAER9HRKupCfwT42y+hTvq4GEZ0HUgpIaqwt5O+Ti/0G2
         gl7lZ5RQOXsZarXAkhVoF37FQzHrWVbioBl0qOVc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.4] ([93.133.68.189]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LoYX0-1gv9rY02yA-00gZ2F; Sat, 01
 Jun 2019 10:37:34 +0200
Cc:     LKML <linux-kernel@vger.kernel.org>
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
Subject: Re: ss: Checking efficient analysis for network connections
To:     Josh Hunt <johunt@akamai.com>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
Date:   Sat, 1 Jun 2019 10:36:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1556674718-5081-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:zahEED2aGN6akXRv9OgQBi63qvgAKWx2Q4CBAVAYjHaUWe43rr9
 3OAjYchsT1vbigmaiTEkyS2m6ICn9k7XRL/nv5AwKB1A1L24/GEP67tJ5I7WdvzD2Dq9XJ9
 GXX/tVg8RTOiIeYJpN0HKSzUF5jPQFVtPXyrCGneY7ACadbdFGlvRhxk6Uad2qyTzJjyUjL
 h5W6jqrvSi335Sdd/0/ew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:p4Nii7LVxbg=:vIoq/L1wVlLwmF+qYKUQob
 sUWNcrMbyfgfzobahVaO7tGv6poILnAigXgUUzOe32oAvwy5hqlNLDRJv/t58+Awp/avRS1ii
 HGxP+eWk64dxadUYJ3EVdZn2c8y1VOidhXaXPEXcXxxobz9ciHqkBwy5BCG6XUq3FSNg85GE1
 207J9jJpqeR+tLXsI4AjcPc1mlatPdPQOrUkv0vA2pCa0swCX/Rhw7xINM62TcUJloU7jLNTg
 GB7v3gKXy8wkP75Sq+7Ei2H6eANLlvpgWym1tr6CczUMwogN6bGkZ7ZzfTXu0uG6mLux/sMgl
 h/MroRbkRDMqxr43fnn+6Q5yYpvxF7pkeHfUG8kAX8LDdNnOEmtOn/rsnqon2PuJMRFmey6vh
 fv5EJ6u+Dv7D0hw9nYNIEGmFoLUmj+fwDbJBBgqmOHn4NPs6VrFaYRirUwrQg6SrwM7x2FFTu
 +qMc3dWZg5oGxhH1fVLS7Yls76Naayrr/hFlODuMWt2ZhGfjsIlZMLSfjRBIRHP7i5QTDyZsa
 +b8Zhk/8fjvmYn5EkhHT4r5N8QJBodGMzvyIm9nYp/xGuwDIIKajvzmmWzaSZfxm4svqaImfK
 MnxlsGhMyzHe7NW8VUbtK3RoGF3gc5/UOwlUz8taVD6yrvP1hUXgdEy53qjaxlkV6++wLgytO
 chHocfK436ZamocYzvaIev8SBLv8YV1up1ljWZEQEeb0AC62iaVozeCxQJyFHYWjZ9z2iyXxI
 k462v6nOHaT+4lVr7AzcTUSoQ+g+fjQFh+zPy87PaabuLWan7eLuU8M0CoBKK8w/gqprNOKyY
 MIM8MsgkywPqblcjQ5ZDruF4DUy80fJEyWr1a7xOAkWh4npGzoXJhnwleyFaPSVzowEJkYpCO
 C76SBf5wLe6LB4Om6cugkf7upWXTgwDys915r24OmtIhl9qEl1R6yzamU458R0YLa/uWkQTM1
 fy2YgkUxcqsAwRX8cPZeYP8nWrW8g66/ZxzF4q2HTPcWsWUaa4VXs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Multi-line output in ss makes it difficult to search for things with grep.

I became more concerned about efficient data processing for the
provided information. There are further software development possibilities
to consider, aren't there?

The chosen data formats influence the software situation considerably.

* Information is exported together with extra space characters.
  Other field delimiters can occasionally be nicer.

* Regular expressions are useful to extract data from text lines.
  But other programming interfaces are safer to work with data structures.
  The mentioned program can be used to filter the provided input.
  But if you would like to work with information from the filtered records,
  you would need to repeat some data processing by the calling process
  so that items will be converted into structured elements.
  Would you like to avoid duplicate work?


I imagine then that it would be also nicer to perform filtering based on
configurable constraints at the data source directly.
How much can Linux help more in this software area?
How do you think about such ideas?

Regards,
Markus
