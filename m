Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32D6183600
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCLQTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:19:37 -0400
Received: from sonic311-14.consmr.mail.bf2.yahoo.com ([74.6.131.124]:40557
        "EHLO sonic311-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgCLQTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 12:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584029976; bh=rLzamwWDU6w+ljUNz15IdfH92SpsSZVAbr+GO8Whobg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=s6zR7BJomQA9We5CLPYaFTpLF01ZGxcTMb6n9Jd/r7/5t4poSN61GsIr8zUD3yK5jgUoq1heK79OOpQbz2c1P1sRcDlSbK0n8kcvtVkMpsunVsmsMxYJVALxJ8H0apGxMrbRJRcJ8DzRFSO+W3feUr+MVg4BZ8jBDnOuPESyCwO5ncNW+aJIWM6t7hGeJ/u9hBz1wF+LPn6ffrCSZ5A3pnpoHDNuW4S6n+o8Fc8LlQ241RoKz77dv9bzzc1eal9E2nOZMgHxvJhTQKjOrpuyAdKh3sO9uO6rPFN+8uDzUiC9v1QbnsPb9lFFnpp19SIqIHwefsFWcc5JcTOVncKzNw==
X-YMail-OSG: dL1O2HEVM1mG7Ud8N0iYgWSi0RL_cfUn5P5KQqS8h68N93nicN2Z9VAkQ1UY8aJ
 qu0UEOjW8Wt6vEFmlijhAVwHYqNT7Fr4wu6EPgrezc3yvh7LkPTaEkyhuSaq2IVuy4yFn6YkR0TE
 sEkmAA7w5cfKocMwOR8JAxFGXGz9jPZ6IPtmLi1zDOgfNg73j8FsgUG.IEE1FlVATs8xzdBNHBhE
 9ptnXgMPMj32KrQLgiZrVemv3WwmVXtsOjJwyef_IYOWk_J2boAtG2bE4AhD.ZpJWSEIr29kLM4k
 Fz8OAmnNdIMQh.rJnm5qaxP.2DzSvTED4zAYiaKxHqf7EsssDXNYZfQ0b5goQ0LFCVC.c21HiFJ0
 NoR9BqsMobBBFxpVZqlSy2DrQ8DAgQbBtXKmQGNulo0LPKZ73ItACNxrnjUjQWWcpClsAQtiMdhn
 xOnGtZNZ0esBbGisAg3xBWN5zSp7d6uMe7HcbGgfHCqXvJZWtD_yLEvgD1IZls2T8hTnoKLCoqE7
 Rs6z7FkhD0SgO7UzNUOaQ.A3KgSToZdqjUz__X8dFl5TYvAj2hfEF6Jjqk9vzljQc2He4S9AytF9
 6a_eIh1LZAvwnH1gqhwqxGKSLAMMPl4eMdHbVk6w7cKwZFKtnhVPwTh.cF7PtpqKttalt.c4zFNh
 U1.N.VU.2JGgKRZaj0LEEtuGL2w1OHT7q6QL0wWIhvvuXNi7JOXD_7SpXLtt6PM69lcGOCVg9ZIh
 Iw9.62.ZsNDqJaK.iybgaFHcrwG.ccBRrXWWE7d8UxJbJUms6ujP9zgfXsUErgy6TxUnTseQxyzb
 t6XnEBBNIrrj_xZk3joEVY8EgVeSLNNlduouQpN4.8XF28BrLS6CCq6alc8vUmHMxqOWODdwHwS_
 WmyemCbiUswQCr8tjDpk_abyt_8eWiTAv8EYrqUO.QhxieEZPMjKNCo7C0rPJeY6A.d4S4P0G04n
 _wpyumRFQ3LJcm5yvmItr_EQzPSrRNHvf02lu_V1vaPPb1BZdFQopzIfcPYOuzXZmGSMrx.Otvhe
 Yq1hS5ZrIrEkKMLTIC_MBg_SpS8uH_HVnUOtkBSPBMCYTXdVTuw813XvZycWPnag9SfuZYvQARZU
 6rls85FuFgJWiQZfz2pDjH7F8KDz5.NrruvJ08hjqOhrtNu3LqK4ZsS70YBRoS61u0LKBrz.Y21Y
 9Ah06fzWr1gIHZkB5_ej6JVVkng7h05MxV_bPU75lEEaky4G6MDPqRwOH7MQLmb4c6HOtIA4OC6u
 GuzFT8RjuOBZD31al3oTaRr9Vz97XKj95zHtus4SCNjGSIcP1bjutjFGjZiVhZVKYRCA.Utx7xNR
 x.B3PdA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Thu, 12 Mar 2020 16:19:36 +0000
Date:   Thu, 12 Mar 2020 16:19:34 +0000 (UTC)
From:   "MR.Abderazack Zebdani" <zebdanimrabderazack@gmail.com>
Reply-To: zebdanimrabderazack@gmail.com
Message-ID: <1405434474.2553545.1584029974362@mail.yahoo.com>
Subject: MY GREETINGS TO YOUR FAMILY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1405434474.2553545.1584029974362.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15342 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious.This letter must come to you as=
 a big surprise, but I believe it is only a day that people meet and become=
 great friends and business partners. Please I want you to read this letter=
 very carefully and I must apologize for barging this message into your mai=
l box without any formal introduction due to the urgency and confidentialit=
y of this business. I make this contact with you as I believe that you can =
be of great assistance to me. My name is Mr.Abderazack Zebdani, from Burkin=
a Faso, West Africa. I work in Bank Of Africa (BOA) as telex manager, pleas=
e see this as a confidential message and do not reveal it to another person=
 and let me know whether you can be of assistance regarding my proposal bel=
ow because it is top secret.

I am about to retire from active Banking service to start a new life but I =
am skeptical to reveal this particular secret to a stranger. You must assur=
e me that everything will be handled confidentially because we are not goin=
g to suffer again in life. It has been 10 years now that most of the greedy=
 African Politicians used our bank to launder money overseas through the he=
lp of their Political advisers. Most of the funds which they transferred ou=
t of the shores of Africa were gold and oil money that was supposed to have=
 been used to develop the continent. Their Political advisers always inflat=
ed the amounts before transferring to foreign accounts, so I also used the =
opportunity to divert part of the funds hence I am aware that there is no o=
fficial trace of how much was transferred as all the accounts used for such=
 transfers were being closed after transfer. I acted as the Bank Officer to=
 most of the politicians and when I discovered that they were using me to s=
ucceed in their greedy act; I also cleaned some of their banking records fr=
om the Bank files and no one cared to ask me because the money was too much=
 for them to control. They laundered over $5billion Dollars during the proc=
ess.

Before I send this message to you, I have already diverted ($10.5million Do=
llars) to an escrow account belonging to no one in the bank. The bank is an=
xious now to know who the beneficiary to the funds because they have made a=
 lot of profits with the funds. It is more than Eight years now and most of=
 the politicians are no longer using our bank to transfer funds overseas. T=
he ($10.5million Dollars) has been laying waste in our bank and I don=E2=80=
=99t want to retire from the bank without transferring the funds to a forei=
gn account to enable me share the proceeds with the receiver (a foreigner).=
 The money will be shared 60% for me and 40% for you. There is no one comin=
g to ask you about the funds because I secured everything. I only want you =
to assist me by providing a reliable bank account where the funds can be tr=
ansferred.

You are not to face any difficulties or legal implications as I am going to=
 handle the transfer personally. If you are capable of receiving the funds,=
 do let me know immediately to enable me give you a detailed information on=
 what to do. For me, I have not stolen the money from anyone because the ot=
her people that took the whole money did not face any problems. This is my =
chance to grab my own life opportunity but you must keep the details of the=
 funds secret to avoid any leakages as no one in the bank knows about my pl=
ans.Please get back to me if you are interested and capable to handle this =
project, I am looking forward to hear from you immediately for further info=
rmation.
Thanks with my best regards.
Mr.Abderazack Zebdani.
Telex Manager
Bank Of Africa (BOA)
Burkina Faso.
