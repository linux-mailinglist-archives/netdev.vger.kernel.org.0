Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E764DFD78
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbfJVGBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:01:17 -0400
Received: from mout.web.de ([212.227.15.14]:50209 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbfJVGBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 02:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1571724058;
        bh=acVU5mOSMaCDgB7gHBcOOWdOdcqUAEkvfKW+ViGn8Kc=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=m7snXKDihF4NUOPCEU7s/jKgeUfxGFPIqX72GTQW1L0kr0K3+brqkbZ8rlCMAgre9
         YmGS85FDzP01NMs8QTfkjqYA66HpXop3rKCeQ+wpCuB0ZwpjmezThG9q1XR6ZFhXBe
         nP0uULxuB8UV6Xfse6IFsFXYuMiosyM/BnRm27Fk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.150.42]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LaIRi-1hapxk1YLO-00m171; Tue, 22
 Oct 2019 08:00:58 +0200
To:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Josh Hunt <johunt@akamai.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20190601.164838.1496580524715275443.davem@davemloft.net>
Subject: Re: [RFC] ss: Checking selected network ports
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <93483314-22eb-0ed6-70b3-044e6e007a34@web.de>
Date:   Tue, 22 Oct 2019 08:00:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20190601.164838.1496580524715275443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:AtDsWwGMqmyZ6n2xHR/7FuRrDqa18Gwm/9QrkNySyB8KOnDnAJI
 WQJI33xdCKv9yu7o3J2ZdEbQSijXaC3OwecqXGeI/qOBwSBO2LKQluVTWLobgXjcWHl3q5M
 V3ckK2VWteuSyfHoo6ufsoN42JiScXhAKzOjqqu0JVD8iiU5J6H5+OdQPv7wE6dpjImsJNm
 MFNnrRo13gTzMhOlL5hbQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:M9nY+nIKi40=:JHcMCW8/HlhjnaW6mYFjdJ
 ETXbGv7vvcbn7RkxxZ6Gm6rC7OB5mVkEIUSe0Eu/yX1th2GuS7xkslTeHu2nXfA6qzuFKg2NW
 zOx3JbNRCBoInO0DxhP1aYEp6PUS/+YkE5h1uuIQ6+jOabWqClO1KHNQHK5cMEIHDeB9kUxFk
 o3rnc8L3pgTR2ys3MvJAygK8JdMA8MqUi9U7OV70DyneRkNgcAH9cEnBllrCsy52pBU1sKOw/
 uxVlV3Igu/kS6H67i/EqbgabprCz7y0oOHVI+v9NF6LjFCZSebyo92iO4l3H6aDMZQhlFLBUa
 c9NlRRlZPgtOyX9JLiFIcjBCUSW1eUBFzR+vvNxwvuPX7nLSmwRvP92NQAVFimhb0DJodUftW
 d9HO84FhLOlv0IvBZALadhm5R68G5xTbi0mXWO5KZHdsSsJ4yST16AjF9FkHJintI7PQVDmVJ
 bjjTJ1fgVQb0jbX6v9CKR/QuOinxhgxiU2eQiwalyUkX0Dw+2CgWeZL3EMlp6CSmIp49A6SvY
 A5OjT8SSI2yqtCHfzJw9sSRB0EdbVXwbmFde0oA5GQevTlgZWf2A5/TWjh+l6W6/i1hOEGAdh
 CGAouYDTKAi38DfMey93+qQk1VbmTTlcNyr+5r51JtfXb/7Yy1JrxJUvwHvyqvnvwznEXB1Fj
 TvyXI9sxut83Ad8VkLqwEgAeydMUaHED4/gG+KBf5Uab4QQ98ry4STa4KdxqPoel95Zk4lTNI
 EN4OMRvyWTC9g26iZdS958HzcQv6yPUWM6V/ZjDnSTN29YJA4NnZfl8srTao/h26cAB76fF3C
 P2lA1ePjyHtnvzltuKyGIW1mVlGyzflbpekEZjRCAE05TyThi7PH2c/1ABr3fcxBJrJfBfgzv
 1RAWLMtyQNHMOhV3R6EUcRrzGCReCVQvCTl1DlDOG4eYXsTvT7y/WSruOKwk7PWJHlsX21cUG
 KcYfqD2Cwg2E/f2iC8OPQY1tviDGe1RyatsDphpQ9K5Y+E3359UxSnhMzSaniGfUQ94oAmf9e
 t1Td3Rll5TWkUpDkEzd+7xIn+u9Hr/m1PgqJmKY50TThjBR+Fg5h9Gs5S6/riVRsRsvtZyHed
 YHMnB6+KL5OWoOlXFKOKE0IQZ0CA20vPdyT1gBFgDTZWzYeIQAV2x18YlFMWhEkB/MNSEYW6b
 Pjz3YjKopphSlTUh6c8cC5K083Ovwgvn/pB7eWnNVjWZ1J5W+ZrCS97WmA3EC05gEjTVGZQ1Y
 NiU7dlEzGbHPTp1jKktXfe2gSHFwibwjGLh0RuBtoPuPqLcGtRu3VjeiAf50=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you use netlink operations directly, you can have the kernel filter
> on various criteria and only get the socket entries you are interested in.

Do any developers care to take another look at current software design options?


> This whole discussion has zero to do with what text format 'ss' outputs.

Is there a need to improve the software documentation any further?

Which programming interface should be used to check the receive queue
for a single port (without retrieving more network data before)?

Regards,
Markus
